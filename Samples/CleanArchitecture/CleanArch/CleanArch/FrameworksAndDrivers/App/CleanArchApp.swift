//
//  CleanArchApp.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import SwiftUI
import Foundation
import RealmSwift
import GRDB

@main
struct CleanArchApp: App {
    private let fetchUserUseCase: FetchUserUseCase

    init() {
        UserDefaults.standard.register(defaults: [
            "app.settings.database.type": DatabaseType.realm.rawValue
        ])

        let provider = Self.resolveDatabaseProvider()

        let repository: UserRepository = {
            if let realmProvider = provider as? RealmProvider {
                return UserRepositoryImpl<RealmProvider>(provider: realmProvider)
            } else if let sqliteProvider = provider as? SQLiteProvider {
                return UserRepositoryImpl<SQLiteProvider>(provider: sqliteProvider)
            } else {
                fatalError("Unsupported provider type")
            }
        }()

#if DEBUG
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

extension CleanArchApp {
    static func resolveDatabaseProvider() -> any DataStoreProvider {
        let settingRawValue = UserDefaults.standard.string(forKey: "app.settings.database.type")!
        let databaseType = DatabaseType(rawValue: settingRawValue) ?? .sqlite

        let config = DatabaseConfiguration(
            type: databaseType,
            filename: "app",
            shouldEncrypt: true
        )

        return DataStoreProviderFactory.makeDatabaseProvider(using: config)
    }
}
