//
//  EncryptionKeyProvider.swift
//  CleanArch
//
//  Created by hiroakit on 2025/07/06.
//

import Foundation
import Security

enum EncryptionKeyProvider {
    private static let keychainKey = "com.cleanarch.database.encryptionkey"
    private static let keyLength = 64

    @MainActor static func provideKey(keyName: String? = nil) throws -> Data {
        let account = keyName ?? keychainKey

        if let existingKey = try? retrieveKeyFromKeychain(account) {
            return existingKey
        }

        var keyData = Data(count: keyLength)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, keyLength, $0.baseAddress!)
        }
        guard result == errSecSuccess else {
            throw NSError(domain: "EncryptionKeyProvider", code: Int(result), userInfo: nil)
        }

        try storeKeyInKeychain(keyData, for: account)
        return keyData
    }

    public static func logKey(_ key: Data) {
        #if DEBUG
        let hex = key.map { String(format: "%02hhx", $0) }.joined()
        print("🔐 Realm Encryption Key (Hex): \(hex)")
        #endif
    }

    private static func retrieveKeyFromKeychain(_ account: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw NSError(domain: "EncryptionKeyProvider", code: Int(status), userInfo: nil)
        }
        return item as? Data
    }

    private static func storeKeyInKeychain(_ key: Data, for account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: key
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "EncryptionKeyProvider", code: Int(status), userInfo: nil)
        }
    }
}
