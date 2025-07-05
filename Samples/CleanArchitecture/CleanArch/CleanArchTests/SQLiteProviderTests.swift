//
//  SQLiteProviderTests.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//


import Foundation
import GRDB
import Testing
@testable import CleanArch

struct SQLiteProviderTests {
    @Test("provide returns a usable database queue")
    func testProvideReturnsDatabaseQueue() throws {
        // Arrange
        let path = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("app.sqlite")
            .path

        let provider = SQLiteProvider(path: path)

        // Act
        let dbQueue = provider.provide()

        // Assert: 書き込み・読み込み可能なことを確認
        try dbQueue.write { db in
            try db.execute(sql: "CREATE TABLE IF NOT EXISTS test_table (id INTEGER PRIMARY KEY, name TEXT)")
            try db.execute(sql: "INSERT INTO test_table (name) VALUES (?)", arguments: ["Test"])
        }

        let name: String? = try dbQueue.read { db in
            try String.fetchOne(db, sql: "SELECT name FROM test_table WHERE id = 1")
        }

        #expect(name == "Test")
    }

    @Test("database file is located in document directory")
    func testDatabaseFilePath() throws {
        // Arrange
        let expectedPath = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("app.sqlite")
            .path

        let provider = SQLiteProvider(path:expectedPath)

        // Act
        let actualPath = provider.provide().path

        // Assert
        #expect(actualPath == expectedPath)
    }
}
