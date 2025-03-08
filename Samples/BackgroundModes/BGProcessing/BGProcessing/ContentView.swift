//
//  ContentView.swift
//  BGProcessing
//
//  Created by hiroakit on 2025/03/02.
//

import SwiftUI
import BackgroundTasks
import os

struct ContentView: View {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "UI")
    
    var body: some View {
        VStack {
            Button("Schedule a Task") {
                scheduleBackgroundTask()
            }
        }
    }
    
    func scheduleBackgroundTask() {
        guard let identifier = Bundle.main.bundleIdentifier else {
            return
        }
        
        let request = BGProcessingTaskRequest(identifier: identifier)
        request.requiresNetworkConnectivity = true
        request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
            logger.notice("Scheduled background task - identifier:\(request.identifier, privacy: .public)")
        } catch {
            logger.error("Failed background task scheduling \(error, privacy: .public)")
        }
    }
}

#Preview {
    ContentView()
}
