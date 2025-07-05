//
//  MockUserRepository.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
@testable import CleanArch

final class MockUserRepository: UserRepository {
    var userStorage: [String: User] = [:]

    func fetchUser(by id: String) -> User? {
        return userStorage[id]
    }

    func saveUser(_ user: User) {
        userStorage[user.id] = user
    }
}
