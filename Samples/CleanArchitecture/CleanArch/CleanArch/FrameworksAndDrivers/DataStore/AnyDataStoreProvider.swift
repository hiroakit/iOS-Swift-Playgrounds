//
//  AnyDataStoreProvider.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation

final class AnyDataStoreProvider<Store>: DataStoreProvider {
    private let _provide: () -> Store

    init<P: DataStoreProvider>(_ provider: P) where P.StoreType == Store {
        self._provide = provider.provide
    }

    func provide() -> Store {
        return _provide()
    }
}
