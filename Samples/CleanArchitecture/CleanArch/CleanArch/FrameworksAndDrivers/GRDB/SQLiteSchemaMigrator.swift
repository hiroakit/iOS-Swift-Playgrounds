//
//  SQLiteSchemaMigrator.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//


import Foundation
import GRDB

struct SQLiteSchemaMigrator {
    static func migrate(_ dbQueue: DatabaseQueue) throws {
        try dbQueue.write { db in
            try db.create(table: "user", ifNotExists: true) { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text)
                t.column("age", .integer)
            }
        }
    }
}
