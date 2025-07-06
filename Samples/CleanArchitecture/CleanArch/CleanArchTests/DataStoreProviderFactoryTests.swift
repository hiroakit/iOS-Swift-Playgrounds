//
//  DataStoreProviderFactoryTests.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/06.
//


import Foundation
import Testing
import RealmSwift
import GRDB
@testable import CleanArch

struct DataStoreProviderFactoryTests {
    @MainActor @Test("makeDatabaseProvider returns RealmProvider for .realm")
    func testMakeRealmProvider() {
        let config = DatabaseConfiguration(type: .realm, filename: "test", shouldEncrypt: false)
        let provider = DataStoreProviderFactory.makeDatabaseProvider(using: config)
        #expect(provider is RealmProvider)

        let realm = (provider as! RealmProvider).provide()
        #expect(realm.configuration.fileURL != nil)
    }

    @MainActor @Test("makeDatabaseProvider returns SQLiteProvider for .sqlite with default path")
    func testMakeSQLiteProviderWithDefaultPath() {
        let config = DatabaseConfiguration(type: .sqlite, filename: "test_default", shouldEncrypt: false)
        let provider = DataStoreProviderFactory.makeDatabaseProvider(using: config)
        #expect(provider is SQLiteProvider)

        let dbQueue = (provider as! SQLiteProvider).provide()
        let tables = try! dbQueue.read { db in
            try String.fetchAll(db, sql: "SELECT name FROM sqlite_master WHERE type='table';")
        }
        #expect(tables.contains("user") || tables.isEmpty)
    }

    @MainActor @Test("makeDatabaseProvider returns SQLiteProvider for .sqlite with custom path")
    func testMakeSQLiteProviderWithCustomPath() {
        let filename = "test_custom"
        let config = DatabaseConfiguration(type: .sqlite, filename: filename, shouldEncrypt: false)
        let provider = DataStoreProviderFactory.makeDatabaseProvider(using: config)
        #expect(provider is SQLiteProvider)

        let dbQueue = (provider as! SQLiteProvider).provide()
        let expectedPath = config.resolvedPath
        let pathInProvider = dbQueue.path
        #expect(pathInProvider == expectedPath)
    }
}
