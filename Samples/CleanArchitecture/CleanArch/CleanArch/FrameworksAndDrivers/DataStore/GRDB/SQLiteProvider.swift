//
//  SQLiteProvider.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
import GRDB

final class SQLiteProvider: DataStoreProvider {
    typealias StoreType = DatabaseQueue

    private let dbQueue: DatabaseQueue

    init(path: String) {
        self.dbQueue = try! DatabaseQueue(path: path)
    }

    func provide() -> DatabaseQueue {
        return dbQueue
    }
}
