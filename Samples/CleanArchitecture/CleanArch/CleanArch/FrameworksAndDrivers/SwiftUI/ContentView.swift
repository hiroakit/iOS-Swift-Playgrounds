//
//  ContentView.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.fetchUserUseCase) private var fetchUserUseCase
    @State private var path: [User] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Show User Detail") {
                    if let user = fetchUserUseCase.execute(id: "abc123") {
                        path.append(user)
                    }
                }
            }
            .navigationTitle("Home")
            .navigationDestination(for: User.self) { user in
                UserDetailView(user: user)
            }
        }
    }
}

private struct FetchUserUseCaseKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue: FetchUserUseCase = DummyFetchUserUseCase()
}

extension EnvironmentValues {
    var fetchUserUseCase: FetchUserUseCase {
        get { self[FetchUserUseCaseKey.self] }
        set { self[FetchUserUseCaseKey.self] = newValue }
    }
}

// Dummy implementation for preview
private struct DummyFetchUserUseCase: FetchUserUseCase {
    func execute(id: String) -> User? {
        return User(id: id, name: "Preview User", age: 30)
    }
}

#Preview {
    ContentView()
        .environment(\.fetchUserUseCase, DummyFetchUserUseCase())
}
