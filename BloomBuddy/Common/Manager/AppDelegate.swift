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
        print(userInfo["payload"])
        guard let payload = userInfo["payload"] as? [String: Any], let jsonData = try? JSONSerialization.data(withJSONObject: payload), let sensorData = try? JSONDecoder().decode(SensorData.self, from: jsonData) else {
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
                /*var seen: [String: [String]] = [:]
                var count: Int = 0
                
                for plant in plants {
                    if let name = plant.collection?.name {
                        if let current = seen[plant.name], !current.contains(name) {
                            seen[plant.name]?.insert(name, at: 0)
                            count += 1
                        } else if seen[plant.name] == nil {
                            seen[plant.name] = [name]
                            count += 1
                        }
                    }
                }
                print(count)*/
                print(needsWater.count)
                if value > 103 || value < -3 {
                    let content = UNMutableNotificationContent()
                    content.sound = .default
                    content.title = "❗️ Ungültiger Wert empfangen ❗️"
                    content.subtitle = "Prüfe ob der Sensorstecker von \(sensorData.name) richtig sitzt"
                    content.body = "Das Problem kann auftreten wenn das Kabel des Sensors nicht richtig oder garnicht mit dem Controller verbunden ist. Um es zu beheben ziehe den Stecker des Sensors aus dem Controller, stecke ihn dann wieder ein und stelle sicher, dass er fest sitzt. Sollte das Problem bestehen, kalibriere ihn neu. Falls das auch nicht hilft, kontaktiere bitte unseren Support."
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    try? await UNUserNotificationCenter.current().add(request)
                    print("sensor weird")
                }
                
                if needsWater.count == 1 {
                    let content = UNMutableNotificationContent()
                    content.sound = UNNotificationSound.default
                    content.title = "\(needsWater.first?.name ?? "Pflanze") ist durstig 🌱💧"
                    content.body = "Sieh mal nach ihr"
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    try? await UNUserNotificationCenter.current().add(request)
                    print("one needs water")
                } else if needsWater.count > 1 {
                    let content = UNMutableNotificationContent()
                    content.sound = UNNotificationSound.default
                    content.title = "Mehrere Pflanzen sind durstig 🌱💧"
                    content.body = "\(sensorData.name) passt auf sie auf, aber schau besser mal nach"
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    try? await UNUserNotificationCenter.current().add(request)
                    print("multiple need water")
                }
                
                if let battery = sensorData.battery, battery == 1 && sensorData.model.hasBattery {
                    let content = UNMutableNotificationContent()
                    content.sound = UNNotificationSound.default
                    content.title = "\(sensorData.name) wird langsam müde 😴"
                    content.body = "Lade ihn demnächst auf"
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    try? await UNUserNotificationCenter.current().add(request)
                    print("battery close to empty")
                }
            } catch {
                print(error.localizedDescription)
            }
            completionHandler(.newData)
        }
    }
}

