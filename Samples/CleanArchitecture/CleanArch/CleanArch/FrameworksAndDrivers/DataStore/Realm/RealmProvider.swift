//
//  RealmProvider.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import RealmSwift

final class RealmProvider: DataStoreProvider {
    typealias StoreType = Realm

    private let realm: Realm

    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.realm = try! Realm(configuration: configuration)
    }

    func provide() -> Realm {
        return realm
    }
}
