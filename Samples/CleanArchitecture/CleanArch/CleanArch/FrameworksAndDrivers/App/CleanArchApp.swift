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
        UserDefaults.standard.register(defaults: [
            "app.settings.database.type": DatabaseType.sqlite.rawValue
        ])
        let settingRawValue = UserDefaults.standard.string(forKey: "app.settings.database.type")!
        let databaseType = DatabaseType(rawValue: settingRawValue) ?? .sqlite
        switch databaseType {
        case .sqlite:
            let resolvedPath = try! FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("app.sqlite")
                .path
#if DEBUG
            print("📁 SQLite file path: \(resolvedPath)")
#endif
            // GRDB does not support `encryptionKey` in Configuration by default unless using SQLCipher.
            // If using SQLCipher integration, ensure the build is correctly configured.
            // var configuration = Configuration()
            // configuration.encryptionKey = try! EncryptionKeyProvider.provideKey()
            return SQLiteProvider(path: resolvedPath, configuration: Configuration())
        case .realm:
            var config = Realm.Configuration.defaultConfiguration
            config.encryptionKey = try! EncryptionKeyProvider.provideKey()
#if DEBUG
            if let realmURL = config.fileURL {
                print("📁 Realm file path: \(realmURL.path)")
            }
            if let encryptionKey = config.encryptionKey {
                EncryptionKeyProvider.logKey(encryptionKey)
            }
#endif
            return RealmProvider(configuration: config)
        }
    }
}
