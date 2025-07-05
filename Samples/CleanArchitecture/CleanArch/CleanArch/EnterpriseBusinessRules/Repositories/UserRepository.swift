//
//  UserRepository.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation

protocol UserRepository {
    func fetchUser(by id: String) -> User?
    func saveUser(_ user: User)
}
