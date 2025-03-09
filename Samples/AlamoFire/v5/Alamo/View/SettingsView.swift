//
//  SettingsView.swift
//  Alamo
//
//  Created by hiroakit on 2025/03/09.
//


import SwiftUI

struct SettingsView: View {
    @AppStorage("apiHost") private var apiHost: String = ""
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                Text("API Host")
                    .font(.headline)
                TextField("https://api.example.com", text: $apiHost)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Text("Current API Host: \(apiHost) \nRestart the app after changing the API Host.")
                    .foregroundColor(.gray)
                    .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
