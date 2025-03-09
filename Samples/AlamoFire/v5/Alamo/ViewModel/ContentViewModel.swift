//
//  WeatherViewModel.swift
//  Alamo
//
//  Created by hiroakit on 2025/03/09.
//


import SwiftUI
import PhotosUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var weatherData: [WeatherForecast] = []
    @Published var selectedVideos: [URL] = []
    @Published var uploadStatus: String = ""
    @Published var isUploading: Bool = false
    private let weatherService: WeatherService
    private let movieService: MovieService
    
    init(networkManager: NetworkManager) {
        self.weatherService = WeatherService(networkManager: networkManager)
        self.movieService = MovieService(networkManager: networkManager)
    }
    
    func fetchWeather() {
        weatherService.fetchWeather { [weak self] data in
            DispatchQueue.main.async {
                self?.weatherData = data
            }
        }
    }
    
    func uploadFiles() {
        guard !selectedVideos.isEmpty else {
            uploadStatus = "No video selected"
            return
        }
        guard !isUploading else {
            return
        }
        isUploading = true
        uploadStatus = "Uploading......"
        
        movieService.uploadFiles(selectedVideos) { [weak self] success, statusCode in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if success {
                    self.uploadStatus = "Upload Successful（HTTP \(statusCode ?? 0)）"
                } else {
                    if let statusCode = statusCode {
                        self.uploadStatus = "Upload Failed（HTTP \(statusCode)）"
                    } else {
                        self.uploadStatus = "Network error occurred"
                    }
                }
                self.isUploading = false
            }
        }
    }
    
    func loadVideos(from items: [PhotosPickerItem]) {
        Task {
            self.selectedVideos = []

            for item in items {
                if let movie = try? await item.loadTransferable(type: Movie.self) {
                    self.selectedVideos.append(movie.url)
                    print("Selected video: \(movie.url)")
                }
            }
        }
    }
}
