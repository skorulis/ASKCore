//  Created by Alexander Skorulis on 20/7/2022.

import Foundation

public protocol PKeyValueStore {
    
    func data(forKey: String) -> Data?
    func string(forKey: String) -> String?
    func set(_ value: Any?, forKey: String)
    func removeObject(forKey: String)
    func double(forKey: String) -> Double
    
}

extension UserDefaults: PKeyValueStore { }

public extension PKeyValueStore {
    
    func set<T: Codable>(codable: T, forKey: String) throws {
        let data = try JSONEncoder().encode(codable)
        set(data, forKey: forKey)
    }
    
    func setOrClear<T: Codable>(codable: T?, forKey: String) throws {
        if let codable {
            try set(codable: codable, forKey: forKey)
        } else {
            removeObject(forKey: forKey)
        }
    }
    
    func codable<T: Codable>(forKey: String, type: T.Type = T.self) throws -> T? {
        guard let data = data(forKey: forKey) else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func date(forKey: String) -> Date? {
        let seconds = self.double(forKey: forKey)
        return Date(timeIntervalSince1970: seconds)
    }
    
    func set(date: Date?, forKey: String) {
        let seconds = date?.timeIntervalSince1970 ?? 0
        self.set(seconds, forKey: forKey)
    }
    
}
