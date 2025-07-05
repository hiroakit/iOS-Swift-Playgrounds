//
//  UserGRDBRow.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
import GRDB

struct UserGRDBRow: Codable, FetchableRecord, PersistableRecord {
    var id: String
    var name: String
    var age: Int
    
    static var databaseTableName: String { "user" }
}

extension UserGRDBRow {
    func toDomain() -> User {
        return User(id: id, name: name, age: age)
    }

    init(from domain: User) {
        self.id = domain.id
        self.name = domain.name
        self.age = domain.age
    }
}
