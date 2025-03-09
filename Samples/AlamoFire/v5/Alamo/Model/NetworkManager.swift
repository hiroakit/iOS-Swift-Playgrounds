//
//  NetworkManager.swift
//  Alamo
//
//  Created by hiroakit on 2025/03/09.
//

import Foundation
import Alamofire

class NetworkManager {
    let session: Session
    private let placeholderApiHostUrl: String = "https://api.example.com"

    init() {
        let apiBaseUrl = UserDefaults.standard.string(forKey: "apiHost") ?? self.placeholderApiHostUrl
        let host = URL(string: apiBaseUrl)?.host ?? "api.example.com"
        print("Using API Host: \(host)")
        let manager = ServerTrustManager(evaluators: [host: DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        self.session = Session(configuration: configuration, serverTrustManager: manager)
    }
    
    func getApiBaseUrl() -> String {
        return UserDefaults.standard.string(forKey: "apiHost") ?? self.placeholderApiHostUrl
    }
}
