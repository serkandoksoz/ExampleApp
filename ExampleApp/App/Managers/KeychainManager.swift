//
//  KeychainManager.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 22.12.2024.
//


import Foundation
import Security
import OSLog

struct KeychainManager {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "KeychainManager")
    
    static func storeOrUpdate(value: String, forKey key: String) {
        guard let valueData = value.data(using: .utf8) else {
            logger.error("KeychainManager: Failed to convert value to data.")
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: valueData
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        if status == errSecItemNotFound {
            SecItemAdd(query.merging(attributes) { (_, new) in new } as CFDictionary, nil)
        } else if status == errSecSuccess {
            logger.info("KeychainManager: Value updated successfully.")
        } else {
            logger.error("KeychainManager: Failed to update value with error: \(status)")
        }
    }
    
    static func retrieve(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrSynchronizable as String: kCFBooleanTrue!  // Include this attribute for iCloud Keychain sync
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let data = item as? Data {
                return String(data: data, encoding: .utf8)
            } else {
                logger.error("KeychainManager: Failed to convert retrieved data to string.")
                return nil
            }
        } else if status == errSecItemNotFound {
            logger.info("KeychainManager: Item not found in the keychain.")
            return nil
        } else {
            logger.error("KeychainManager: Failed to retrieve item with error: \(status)")
            return nil
        }
    }
    
    static func update(value: String, forKey key: String) {
        guard let valueData = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: valueData
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
            storeOrUpdate(value: value, forKey: key)
        }
    }
    
    static func clearKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            logger.info("KeychainManager: Keychain cleared successfully.")
        } else {
            logger.error("KeychainManager: Failed to clear keychain with error: \(status)")
        }
    }
    
    static func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        switch status {
        case errSecSuccess:
            logger.info("KeychainManager: Item successfully deleted.")
        case errSecItemNotFound:
            logger.info("KeychainManager: Item not found in the keychain.")
        default:
            logger.error("KeychainManager: Failed to delete item with error: \(status)")
        }
    }
}
