//
//  UserRepositoryImpl.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
import GRDB
import RealmSwift

final class UserRepositoryImpl<Provider: DataStoreProvider>: UserRepository {
    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    func fetchUser(by id: String) -> User? {
        let store = provider.provide()
        if let dbQueue = store as? DatabaseQueue {
            return try? dbQueue.read { db in
                try UserGRDBRow.fetchOne(db, key: id)?.toDomain()
            }
        } else if let realm = store as? Realm {
            return realm.object(ofType: UserRealmObject.self, forPrimaryKey: id)?.toDomain()
        } else {
            return nil
        }
    }

    func saveUser(_ user: User) {
        let store = provider.provide()
        if let dbQueue = store as? DatabaseQueue {
            let row = UserGRDBRow(from: user)
            try? dbQueue.write { db in
                try row.save(db)
            }
        } else if let realm = store as? Realm {
            let object = UserRealmObject(from: user)
            try? realm.write {
                realm.add(object, update: .modified)
            }
        }
    }
}
