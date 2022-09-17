//  Created by Alexander Skorulis on 20/7/2022.

import Foundation

public protocol PKeyValueStore {
    
    func data(forKey: String) -> Data?
    func set(_ value: Any?, forKey: String)
    func removeObject(forKey: String)
    
}

extension UserDefaults: PKeyValueStore { }

public extension PKeyValueStore {
    
    func set<T: Codable>(codable: T, forKey: String) throws {
        let data = try JSONEncoder().encode(codable)
        set(data, forKey: forKey)
    }
    
    func codable<T: Codable>(forKey: String, type: T.Type = T.self) throws -> T? {
        guard let data = data(forKey: forKey) else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
