//
//  ContentView.swift
//  Alamo
//
//  Created by hiroakit on 2025/03/02.
//

import SwiftUI
import PhotosUI
import AVKit

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isSettingsPresented = false
    
    init() {
        let networkManager = NetworkManager()
        _viewModel = StateObject(wrappedValue: ContentViewModel(networkManager: networkManager))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.uploadStatus)
                    .onAppear {
                        if selectedItems.count < 1 {
                            viewModel.uploadStatus = "No video selected"
                        }
                    }
                HStack {
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .videos) {
                        Text("Select videos")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .onChange(of: selectedItems) { _, newItems in
                        viewModel.uploadStatus = ""
                        if selectedItems.count < 1 {
                            viewModel.uploadStatus = "No video selected"
                        }
                        viewModel.loadVideos(from: newItems)
                    }

                    Button(action: {
                        viewModel.uploadFiles()
                    }) {
                        HStack {
                            if viewModel.isUploading {
                                ProgressView()
                                    .padding(.trailing, 5)
                            }
                            Text(viewModel.isUploading ? "Uploading..." : "Upload Files")
                        }
                        .padding()
                        .background(viewModel.isUploading ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(viewModel.isUploading)
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.selectedVideos, id: \.self) { url in
                            VideoPlayer(player: AVPlayer(url: url))
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
                
                Button("Fetch Weather") {
                    viewModel.fetchWeather()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                List(viewModel.weatherData) { weather in
                    VStack(alignment: .leading) {
                        Text(weather.summary)
                    }
                }
            }
            .padding()
            .navigationTitle("API Testing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSettingsPresented = true
                    }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
