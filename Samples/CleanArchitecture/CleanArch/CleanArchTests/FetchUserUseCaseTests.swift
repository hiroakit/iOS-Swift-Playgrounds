//
//  FetchUserUseCaseTests.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import Foundation
import Testing
@testable import CleanArch

struct FetchUserUseCaseTests {
    @Test("execute returns expected user")
    func testExecuteReturnsUser() {
        // Arrange
        let repository = MockUserRepository()
        let expectedUser = User(id: "xyz789", name: "Ichiro", age: 40)
        repository.saveUser(expectedUser)

        let useCase = FetchUserUseCase(repository: repository)

        // Act
        let result = useCase.execute(id: "xyz789")

        // Assert
        #expect(result != nil)
        #expect(result?.id == expectedUser.id)
        #expect(result?.name == expectedUser.name)
        #expect(result?.age == expectedUser.age)
    }

    @Test("execute returns nil for unknown id")
    func testExecuteReturnsNilWhenUserNotFound() {
        // Arrange
        let repository = MockUserRepository()
        let useCase = FetchUserUseCase(repository: repository)

        // Act
        let result = useCase.execute(id: "unknown")

        // Assert
        #expect(result == nil)
    }
}
