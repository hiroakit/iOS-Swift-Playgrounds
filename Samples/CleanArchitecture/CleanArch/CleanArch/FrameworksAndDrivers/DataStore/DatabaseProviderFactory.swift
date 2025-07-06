//
//  DatabaseProviderFactory.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
import RealmSwift
import GRDB

struct DatabaseConfiguration {
    let type: DatabaseType
    let filename: String
    let shouldEncrypt: Bool

    var resolvedPath: String {
        let fileExtension: String
        switch type {
        case .sqlite:
            fileExtension = "sqlite"
        case .realm:
            fileExtension = "realm"
        }
        let fullFilename = "\(filename).\(fileExtension)"
        return try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(fullFilename)
            .path
    }
}

enum DataStoreProviderFactory {
    @MainActor static func makeDatabaseProvider(using configuration: DatabaseConfiguration) -> any DataStoreProvider {
        switch configuration.type {
        case .realm:
            var config = Realm.Configuration.defaultConfiguration
            config.fileURL = URL(fileURLWithPath: configuration.resolvedPath)
            if configuration.shouldEncrypt {
                config.encryptionKey = try? EncryptionKeyProvider.provideKey()
            }
#if DEBUG
            if let realmURL = config.fileURL {
                print("📁 Realm file path: \(realmURL.path)")
            }
            if let encryptionKey = config.encryptionKey {
                EncryptionKeyProvider.logKey(encryptionKey)
            }
#endif
            return RealmProvider(configuration: config)
        case .sqlite:
            let resolvedPath = configuration.resolvedPath
#if DEBUG
            print("📁 SQLite file path: \(resolvedPath)")
#endif
            let provider = SQLiteProvider(path: resolvedPath)
            do {
                try SQLiteSchemaMigrator.migrate(provider.provide())
            } catch {
                #if DEBUG
                print("❌ SQLite migration failed: \(error.localizedDescription)")
                #endif
            }
            return provider
        }
    }
}
