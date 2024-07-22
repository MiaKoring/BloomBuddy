//
//  NotificationManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.07.24.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    static var allowedUDKey = "notificationsAllowed"
    
    static func requestAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
                UserDefaults.standard.setValue(true, forKey: allowedUDKey)
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func sendNotification(_ title: String, description: String = "", sound: UNNotificationSound = UNNotificationSound.default) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = description
        content.sound = sound
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
 
