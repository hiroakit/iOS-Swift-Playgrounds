//
//  UserRepositoryImpl.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
import GRDB

final class UserRepositoryImpl<Provider: DataStoreProvider>: UserRepository
where Provider.StoreType == DatabaseQueue {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    func fetchUser(by id: String) -> User? {
        let dbQueue = provider.provide()
        return try? dbQueue.read { db in
            try UserGRDBRow.fetchOne(db, key: id)?.toDomain()
        }
    }

    func saveUser(_ user: User) {
        let dbQueue = provider.provide()
        let row = UserGRDBRow(from: user)
        try? dbQueue.write { db in
            try row.save(db)
        }
    }
}
