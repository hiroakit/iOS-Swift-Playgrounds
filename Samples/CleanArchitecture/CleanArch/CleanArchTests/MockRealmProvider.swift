//
//  MockRealmProvider.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/06.
//

import Foundation
import RealmSwift
@testable import CleanArch

struct MockRealmProvider: DataStoreProvider {
    typealias StoreType = Realm
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func provide() -> Realm {
        return realm
    }
}
