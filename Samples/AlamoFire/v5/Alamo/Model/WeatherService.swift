//
//  WeatherService.swift
//  Alamo
//
//  Created by hiroakit on 2025/03/09.
//


import Foundation
import Alamofire

class WeatherService {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func fetchWeather(completion: @escaping ([WeatherForecast]) -> Void) {
        let baseUrl = networkManager.getApiBaseUrl()
        let url = "\(baseUrl)/api/v1/weatherforecast"
        
        networkManager.session.request(url)
            .validate()
            .responseDecodable(of: [WeatherForecast].self) { response in
                switch response.result {
                case .success(let data):
                    completion(data)
                case .failure(let error):
                    print("Failed to fetch weather data: \(error.localizedDescription)")
                    completion([])
                }
            }
    }
}
