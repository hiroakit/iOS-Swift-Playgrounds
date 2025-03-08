//
//  AppDelegate.swift
//  BGProcessing
//
//  Created by hiroakit on 2025/03/02.
//

import SwiftUI
import BackgroundTasks
import os

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "Launch")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let identifier = Bundle.main.bundleIdentifier {
            self.logger.notice("Registering launch handler for background tasks - identifier: \(identifier)")
            BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil) { task in
                self.handleBackgroundTask(task: task as! BGProcessingTask)
            }
        }
        
        return true
    }

    func handleBackgroundTask(task: BGProcessingTask) {
        self.logger.notice("Background task execution - identifier: \(task.identifier, privacy: .public)")

        task.expirationHandler = {
            self.logger.notice("Background task has expired - identifier: \(task.identifier, privacy: .public)")
            task.setTaskCompleted(success: false)
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            self.logger.notice("Background task completed - identifier: \(task.identifier, privacy: .public)")
            task.setTaskCompleted(success: true)
        }
    }
}
