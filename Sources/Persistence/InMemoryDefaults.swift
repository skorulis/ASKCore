//  Created by Alexander Skorulis on 20/7/2022.

import Foundation

public final class InMemoryDefaults {
    
    var storage: [String: Any] = [:]
    
    public init() {}
    
}

extension InMemoryDefaults: PKeyValueStore {
    public func data(forKey: String) -> Data? {
        return storage[forKey] as? Data
    }
    
    public func set(_ value: Any?, forKey: String) {
        if let value = value {
            storage[forKey] = value
        } else {
            storage.removeValue(forKey: forKey)
        }
    }
    
    public func removeObject(forKey: String) {
        storage.removeValue(forKey: forKey)
    }
    
    public func string(forKey: String) -> String? {
        return storage[forKey] as? String
    }
    
    public func double(forKey: String) -> Double {
        return (storage[forKey] as? Double) ?? 0
    }
    
    
}
