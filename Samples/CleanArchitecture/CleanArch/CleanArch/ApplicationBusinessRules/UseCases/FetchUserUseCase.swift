//
//  FetchUserUseCase.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

protocol FetchUserUseCase {
    func execute(id: String) -> User?
}
