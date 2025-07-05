//
//  UserRepositoryTests.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//


import Testing
import GRDB
@testable import CleanArch

struct UserRepositoryTests {
    let dbQueue: DatabaseQueue
    let repository: UserRepository

    init() {
        dbQueue = try! DatabaseQueue()
        try! dbQueue.write { db in
            try db.create(table: "user", ifNotExists: true) { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text)
                t.column("age", .integer)
            }
        }
        let provider = MockSQLiteProvider(dbQueue: dbQueue)
        self.repository = UserRepositoryImpl(provider: provider)
    }
    
    @Test("saveUser stores user correctly")
    func testSaveUser() throws {
        // Arrange
        let expected = User(id: "def456", name: "Hanako", age: 30)

        // Act
        repository.saveUser(expected)

        // Assert
        let fetched = try dbQueue.read { db in
            try UserGRDBRow.fetchOne(db, key: expected.id)
        }

        #expect(fetched != nil)
        #expect(fetched?.id == expected.id)
        #expect(fetched?.name == expected.name)
        #expect(fetched?.age == expected.age)
    }

    @Test("fetchUser returns the expected User")
    func testFetchUser() throws {
        let expected = User(id: "abc123", name: "Taro", age: 25)
        let row = UserGRDBRow(from: expected)
        try dbQueue.write { db in
            try row.insert(db)
        }

        let fetched = repository.fetchUser(by: "abc123")

        #expect(fetched != nil)
        #expect(fetched?.id == expected.id)
        #expect(fetched?.name == expected.name)
        #expect(fetched?.age == expected.age)
    }
}
