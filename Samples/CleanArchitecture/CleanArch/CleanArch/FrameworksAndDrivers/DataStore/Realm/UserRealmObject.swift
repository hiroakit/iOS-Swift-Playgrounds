//
//  UserRealmObject.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//


import Foundation
import RealmSwift

final class UserRealmObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var age: Int

    convenience init(id: String, name: String, age: Int) {
        self.init()
        self.id = id
        self.name = name
        self.age = age
    }

    convenience init(from user: User) {
        self.init(id: user.id, name: user.name, age: user.age)
    }

    func toDomain() -> User {
        return User(id: self.id, name: self.name, age: self.age)
    }
}