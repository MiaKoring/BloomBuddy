//
//  NotificationManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.07.24.
//

import Foundation
import BackgroundTasks

struct BGTaskManager {
    static func scheduleWaterCheck() {
        let request = BGAppRefreshTaskRequest(identifier: waterCheckTaskId)
        request.earliestBeginDate = .now.addingTimeInterval(1) //TODO: Change Time
        do {
            try BGTaskScheduler.shared.submit(request)
            print("succeeded")
        } catch {
            print(error.localizedDescription)
        }
    }
}
