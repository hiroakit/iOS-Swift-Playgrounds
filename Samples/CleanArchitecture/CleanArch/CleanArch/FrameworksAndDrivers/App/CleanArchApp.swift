//
//  CleanArchApp.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import SwiftUI
import Foundation
import GRDB

@main
struct CleanArchApp: App {
    private let fetchUserUseCase: FetchUserUseCase

    init() {
        let path = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("app.sqlite")
            .path
        let provider = SQLiteProvider(path: path)
        try! SQLiteSchemaMigrator.migrate(provider.provide())
        
#if DEBUG
        // 雑なテストデータ投入
        let repository = UserRepositoryImpl(provider: provider)
        let mockUser = User(id: "abc123", name: "Taro", age: 25)
        repository.saveUser(mockUser)
#endif
        
        self.fetchUserUseCase = FetchUserUseCaseImpl(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.fetchUserUseCase, self.fetchUserUseCase)
        }
    }
}
