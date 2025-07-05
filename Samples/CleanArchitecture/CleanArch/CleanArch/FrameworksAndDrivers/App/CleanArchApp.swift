//
//  CleanArchApp.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/05.
//

import SwiftUI
import Foundation
import RealmSwift
import GRDB

@main
struct CleanArchApp: App {
    private let fetchUserUseCase: FetchUserUseCase

    init() {
        let useRealm = true

        let repository: UserRepository = {
            if useRealm {
                let config = Realm.Configuration.defaultConfiguration
                let provider = AnyDataStoreProvider(RealmProvider(configuration: config))
                return UserRepositoryImpl<AnyDataStoreProvider<Realm>>(provider: provider)
            } else {
                let path = try! FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("app.sqlite")
                    .path
                
                let provider = AnyDataStoreProvider(SQLiteProvider(path: path))
                try! SQLiteSchemaMigrator.migrate(provider.provide())
                return UserRepositoryImpl<AnyDataStoreProvider<DatabaseQueue>>(provider: provider)
            }
        }()

#if DEBUG
        let mockUser = User(id: "abc123", name: "Taro", age: 25)
        repository.saveUser(mockUser)
#endif
        self.fetchUserUseCase = FetchUserUseCaseImpl(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.fetchUserUseCase, self.fetchUserUseCase)
        }
    }
}
