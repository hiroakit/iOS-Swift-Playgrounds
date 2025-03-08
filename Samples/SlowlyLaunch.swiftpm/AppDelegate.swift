import UIKit
import os

class AppDelegate: NSObject, UIApplicationDelegate {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "SlowlyLaunch",
                                category: "Launch")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        logger.log("Start didFinishLaunchingWithOptions")
        sleep(25)
        logger.log("End didFinishLaunchingWithOptions")
        return true
    }
}
