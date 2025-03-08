import SwiftUI
import os

struct ContentView: View {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "UI")

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)

            Button("Print log") {
                NSLog("NSLog: Pushed button")
                logger.info("Logger info: Pushed button")
                logger.log("Logger log: Pushed button")
                logger.warning("Logger warning: Pushed button")
                logger.error("Logger error: Pushed button")
            }
            .padding()
        }
    }
}
