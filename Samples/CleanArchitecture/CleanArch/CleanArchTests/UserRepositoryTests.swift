//
//  UserRepositoryTests.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Testing
import GRDB
import RealmSwift
@testable import CleanArch

struct UserRepositorySQLiteTests {
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

struct UserRepositoryRealmTests {
    let realm: Realm
    let repository: UserRepository

    init() {
        var config = Realm.Configuration(inMemoryIdentifier: "UserRepositoryRealmTests")
        config.deleteRealmIfMigrationNeeded = true
        self.realm = try! Realm(configuration: config)
        let provider = MockRealmProvider(realm: realm)
        self.repository = UserRepositoryImpl(provider: provider)
    }

    @Test("saveUser stores user correctly in Realm")
    func testSaveUser() throws {
        // Arrange
        let expected = User(id: "def456", name: "Hanako", age: 30)

        // Act
        repository.saveUser(expected)

        // Assert
        let fetchedObject = realm.object(ofType: UserRealmObject.self, forPrimaryKey: expected.id)
        #expect(fetchedObject != nil)
        #expect(fetchedObject?.id == expected.id)
        #expect(fetchedObject?.name == expected.name)
        #expect(fetchedObject?.age == expected.age)
    }

    @Test("fetchUser returns the expected User from Realm")
    func testFetchUser() throws {
        // Arrange
        let expected = User(id: "abc123", name: "Taro", age: 25)
        let realmObject = UserRealmObject(from: expected)
        try! realm.write {
            realm.add(realmObject)
        }

        // Act
        let fetched = repository.fetchUser(by: expected.id)

        // Assert
        #expect(fetched != nil)
        #expect(fetched?.id == expected.id)
        #expect(fetched?.name == expected.name)
        #expect(fetched?.age == expected.age)
    }
}
