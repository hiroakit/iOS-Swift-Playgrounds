//
//  RealmProviderTests.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/06.
//

import Testing
import RealmSwift
@testable import CleanArch

struct RealmProviderTests {
    let configuration: Realm.Configuration

    init() {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "RealmProviderTests"
        config.deleteRealmIfMigrationNeeded = true
        self.configuration = config
    }

    @Test("provide returns correct in-memory Realm instance")
    func testProvide() {
        let provider = RealmProvider(configuration: configuration)
        let realm = provider.provide()

        #expect(realm.configuration.inMemoryIdentifier == "RealmProviderTests")
        #expect(!realm.isFrozen)
    }

    @Test("writes and reads object using provided Realm")
    func testRealmWriteAndRead() {
        let provider = RealmProvider(configuration: configuration)
        let realm = provider.provide()

        let user = User(id: "abc123", name: "Taro", age: 25)
        let object = UserRealmObject(from: user)

        try! realm.write {
            realm.add(object)
        }

        let fetched = realm.object(ofType: UserRealmObject.self, forPrimaryKey: "abc123")
        #expect(fetched != nil)
        #expect(fetched?.name == "Taro")
        #expect(fetched?.age == 25)
    }
}
