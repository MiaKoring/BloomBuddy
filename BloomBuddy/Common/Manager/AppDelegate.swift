//
//  AppDelegate.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.11.24.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {    
    var app: BloomBuddyApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        print("registered for remote notifications")
                    }
                } else {
                    print("Notification authorization denied")
                }
            }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let stringifiedToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("stringifiedToken:", stringifiedToken)
        
        Task {
            let token = await BBAuthManager.jwt()
            switch token {
            case .success(let authToken):
                _ = await BloomBuddyController.request(.registerDevice(stringifiedToken, authToken), expected: String.self)
            case .failure:
                break
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
        
        // Optional: Log more detailed error information
        if let nsError = error as NSError? {
            print("Error domain: \(nsError.domain)")
            print("Error code: \(nsError.code)")
            print("Error userInfo: \(nsError.userInfo)")
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .list, .sound]
    }
    
    //Backgroundnotification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // process data
        print(userInfo)
        guard let payload = userInfo as? [String: Any], let jsonData = try? JSONSerialization.data(withJSONObject: payload), let sensorData = try? JSONDecoder().decode(SensorData.self, from: jsonData) else {
            print("failed to decode payload")
            return
        }
        Task {
            do {
                print("called")
                let plants = try await SwiftDataManager.allPlants(withSensorId: sensorData.id)
                print(plants.description)
                guard let value = sensorData.sensor else {
                    return
                }
                
                let needsWater: [Plant] = plants.filter({$0.waterRequirement - 15 > Int(value) && $0.collection?.name != nil})

                print(needsWater.count)
                if value > 103 || value < -3 {
                    var lastWeirdNotifications = UDKey.lastWeirdPush.value as? [String: Int] ?? [:]
                    if lastWeirdNotifications[sensorData.id.uuidString] ?? 0 < Date().timeIntervalSinceReferenceDate.int - 3600 * 6 {
                        
                        let content = UNMutableNotificationContent()
                        content.sound = .default
                        content.title = "❗️ Ungültiger Wert empfangen ❗️"
                        content.subtitle = "Prüfe ob der Sensorstecker von \(sensorData.name) richtig sitzt"
                        content.body = "Das Problem kann auftreten wenn das Kabel des Sensors nicht richtig oder garnicht mit dem Controller verbunden ist. Um es zu beheben ziehe den Stecker des Sensors aus dem Controller, stecke ihn dann wieder ein und stelle sicher, dass er fest sitzt. Sollte das Problem bestehen, kalibriere ihn neu. Falls das auch nicht hilft, kontaktiere bitte unseren Support."
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        try? await UNUserNotificationCenter.current().add(request)
                        lastWeirdNotifications[sensorData.id.uuidString] = Date().timeIntervalSinceReferenceDate.int
                        UDKey.lastWeirdPush.value = lastWeirdNotifications
                    }
                    print("sensor weird")
                }
                
                var lastWaterNotifications = UDKey.lastWaterNotification.value as? [String: Int] ?? [:]
                if lastWaterNotifications[sensorData.id.uuidString] ?? 0 < Date().timeIntervalSinceReferenceDate.int - 3600 * 6 {
                    if needsWater.count == 1 {
                        let content = UNMutableNotificationContent()
                        content.sound = UNNotificationSound.default
                        content.title = "\(needsWater.first?.name ?? "Pflanze") ist durstig 🌱💧"
                        content.body = "Sieh mal nach ihr"
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        try? await UNUserNotificationCenter.current().add(request)
                        lastWaterNotifications[sensorData.id.uuidString] = Date().timeIntervalSinceReferenceDate.int
                        UDKey.lastWaterNotification.value = lastWaterNotifications
                        print("one needs water")
                    } else if needsWater.count > 1 {
                        let content = UNMutableNotificationContent()
                        content.sound = UNNotificationSound.default
                        content.title = "Mehrere Pflanzen sind durstig 🌱💧"
                        content.body = "\(sensorData.name) passt auf sie auf, aber schau besser mal nach"
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        try? await UNUserNotificationCenter.current().add(request)
                        lastWaterNotifications[sensorData.id.uuidString] = Date().timeIntervalSinceReferenceDate.int
                        UDKey.lastWaterNotification.value = lastWaterNotifications
                        print("multiple need water")
                    }
                }
                var lastBatteryNotifications = UDKey.lastBatteryNotification.value as? [String: Int] ?? [:]
                if let battery = sensorData.battery, battery == 1 && sensorData.model.hasBattery && lastBatteryNotifications[sensorData.id.uuidString] ?? 0 < Date().timeIntervalSinceReferenceDate.int - 3600 * 3 {
                    let content = UNMutableNotificationContent()
                    content.sound = UNNotificationSound.default
                    content.title = "\(sensorData.name) wird langsam müde 😴"
                    content.body = "Lade ihn demnächst auf"
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    try? await UNUserNotificationCenter.current().add(request)
                    lastBatteryNotifications[sensorData.id.uuidString] = Date().timeIntervalSinceReferenceDate.int
                    UDKey.lastBatteryNotification.value = lastBatteryNotifications
                    print("battery close to empty")
                }
            } catch {
                print(error.localizedDescription)
            }
            completionHandler(.newData)
        }
    }
}

