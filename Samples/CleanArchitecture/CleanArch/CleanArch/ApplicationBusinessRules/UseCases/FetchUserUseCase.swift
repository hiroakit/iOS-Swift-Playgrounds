//
//  FetchUserUseCase.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation

final class FetchUserUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(id: String) -> User? {
        return repository.fetchUser(by: id)
    }
}
