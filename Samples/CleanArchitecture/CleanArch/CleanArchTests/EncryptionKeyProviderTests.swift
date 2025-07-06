//
//  EncryptionKeyProviderTests.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/06.
//

import Foundation
import Testing
@testable import CleanArch

struct EncryptionKeyProviderTests {
    @MainActor @Test("provideKey returns a 64-byte key")
    func testKeyLength() throws {
        let key = try EncryptionKeyProvider.provideKey()
        #expect(key.count == 64)
    }
    
    @MainActor @Test("storeKeyInKeychain is triggered when no key exists")
    func testStoreKeyInKeychainIndirectly() throws {
        // Delete any existing key
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "com.cleanarch.test.database.encryptionkey"
        ]
        SecItemDelete(query as CFDictionary)

        // Generate a new key (this should call storeKeyInKeychain internally)
        let newKey = try EncryptionKeyProvider.provideKey(keyName: "com.cleanarch.test.database.encryptionkey")

        // Retrieve the stored key and verify it's the same
        let fetchedKey = try EncryptionKeyProvider.provideKey(keyName: "com.cleanarch.test.database.encryptionkey")
        #expect(newKey == fetchedKey)
    }

    @MainActor @Test("provideKey returns the same key on repeated calls")
    func testKeyIsConsistent() throws {
        let key1 = try EncryptionKeyProvider.provideKey()
        let key2 = try EncryptionKeyProvider.provideKey()
        #expect(key1 == key2)
    }

    @Test("logKey does not crash")
    func testLogKey() {
        let dummyKey = Data(repeating: 0xAB, count: 64)
        EncryptionKeyProvider.logKey(dummyKey)
        #expect(true) // just to confirm no crash
    }
}
