//  Created by Alexander Skorulis on 6/6/2026.

import Foundation
import Security

public final class RealSecureKeyValueStore {
    
    private let service: String
    
    public init(service: String) {
        self.service = service
    }
    
    private func baseQuery(forKey key: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
    }
    
    private func write(data: Data, forKey key: String) {
        let query = baseQuery(forKey: key)
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecSuccess {
            let attributes: [String: Any] = [kSecValueData as String: data]
            status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        } else if status == errSecItemNotFound {
            var addQuery = query
            addQuery[kSecValueData as String] = data
            addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            status = SecItemAdd(addQuery as CFDictionary, nil)
        }
        
        if status != errSecSuccess {
            print("Failure to write data to keychain for key \(key): \(status)")
        }
    }
    
}

extension RealSecureKeyValueStore: SecureKeyValueStore {
    public func data(forKey: String) -> Data? {
        var query = baseQuery(forKey: forKey)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else {
            return nil
        }
        return result as? Data
    }
    
    public func set(_ value: Any?, forKey: String) {
        guard let value else {
            removeObject(forKey: forKey)
            return
        }
        if let string = value as? String {
            write(data: Data(string.utf8), forKey: forKey)
        } else if let data = value as? Data {
            write(data: data, forKey: forKey)
        } else if let double = value as? Double {
            var bitPattern = double.bitPattern
            write(data: Data(bytes: &bitPattern, count: MemoryLayout<UInt64>.size), forKey: forKey)
        } else {
            fatalError("Could not write \(value) to keychain")
        }
    }
    
    public func string(forKey: String) -> String? {
        guard let data = data(forKey: forKey) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    public func removeObject(forKey: String) {
        let query = baseQuery(forKey: forKey)
        SecItemDelete(query as CFDictionary)
    }
    
    public func double(forKey: String) -> Double {
        guard let data = data(forKey: forKey), data.count == MemoryLayout<UInt64>.size else {
            return 0
        }
        return data.withUnsafeBytes { buffer in
            Double(bitPattern: buffer.load(as: UInt64.self))
        }
    }
}
