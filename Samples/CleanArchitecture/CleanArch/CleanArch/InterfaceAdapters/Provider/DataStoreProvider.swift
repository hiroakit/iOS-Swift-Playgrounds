//
//  DataStoreProvider.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

protocol DataStoreProvider {
    associatedtype StoreType
    func provide() -> StoreType
}

enum DatabaseType: String {
    case realm
    case sqlite
}
