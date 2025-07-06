//
//  DatabaseProviderFactory.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
import RealmSwift
import GRDB

enum DataStoreProviderFactory {
    static func makeDatabaseProvider(for type: DatabaseType, path: String? = nil) -> any DataStoreProvider {
        switch type {
        case .realm:
            let config = Realm.Configuration.defaultConfiguration
            return RealmProvider(configuration: config)
        case .sqlite:
            let resolvedPath = path ?? (try! FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("app.sqlite")
                .path)
            let provider = SQLiteProvider(path: resolvedPath)
            try! SQLiteSchemaMigrator.migrate(provider.provide())
            return provider
        }
    }
}
