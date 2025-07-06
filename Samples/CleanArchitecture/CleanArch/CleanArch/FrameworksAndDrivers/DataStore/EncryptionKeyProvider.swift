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

    static func provideKey() throws -> Data {
        if let existingKey = try? retrieveKeyFromKeychain() {
            return existingKey
        }

        var keyData = Data(count: keyLength)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, keyLength, $0.baseAddress!)
        }
        guard result == errSecSuccess else {
            throw NSError(domain: "EncryptionKeyProvider", code: Int(result), userInfo: nil)
        }

        try storeKeyInKeychain(keyData)
        return keyData
    }

    public static func logKey(_ key: Data) {
        #if DEBUG
        let hex = key.map { String(format: "%02hhx", $0) }.joined()
        print("🔐 Realm Encryption Key (Hex): \(hex)")
        #endif
    }

    private static func retrieveKeyFromKeychain() throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
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

    private static func storeKeyInKeychain(_ key: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecValueData as String: key
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "EncryptionKeyProvider", code: Int(status), userInfo: nil)
        }
    }
}
