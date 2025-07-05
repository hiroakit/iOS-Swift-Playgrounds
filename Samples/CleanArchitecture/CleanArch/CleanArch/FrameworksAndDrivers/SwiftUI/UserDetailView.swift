//
//  UserDetailView.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//


import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        VStack(spacing: 16) {
            Text("Name: \(user.name)")
            Text("Age: \(user.age)")
        }
        .navigationTitle("User Detail")
        .padding()
    }
}