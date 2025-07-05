//
//  MockSQLiteProvider.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
import GRDB
@testable import CleanArch

final class MockSQLiteProvider: DataStoreProvider {
    typealias StoreType = DatabaseQueue
    private let queue: DatabaseQueue

    init(dbQueue: DatabaseQueue) {
        self.queue = dbQueue
    }

    func provide() -> DatabaseQueue {
        return queue
    }
}
