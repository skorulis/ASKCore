//  Created by Alexander Skorulis on 29/12/2025.

import Foundation

public final class FileSystemKeyValueStore {
    
    private let fileManager: FileManager
    private let baseFolder: URL
    
    public init(
        fileManager: FileManager = .default,
        folderName: String
    ) {
        self.fileManager = fileManager
        
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectoryURL = urls[0]
        baseFolder = documentsDirectoryURL.appending(path: folderName)
        
        if !fileManager.fileExists(at: baseFolder) {
            try! fileManager.createDirectory(at: baseFolder, withIntermediateDirectories: true)
        }
    }
    
    private func url(for key: String) -> URL {
        return baseFolder.appending(path: key)
    }
    
    private func write(data: Data, for key: String) {
        do {
            try data.write(to: url(for: key))
        } catch {
            print("Failure to write data to \(url(for: key))")
        }
    }
    
    public func removeAll() throws {
        try fileManager.removeItem(at: baseFolder)
    }
}

extension FileSystemKeyValueStore: PKeyValueStore {
    public func data(forKey: String) -> Data? {
        guard fileManager.fileExists(at: url(for: forKey)) else {
            return nil
        }
        do {
            return try Data(contentsOf: url(for: forKey))
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    public func set(_ value: Any?, forKey: String) {
        guard let value else {
            removeObject(forKey: forKey)
            return
        }
        if let string = value as? String {
            let data = string.data(using: .utf8)!
            write(data: data, for: forKey)
        } else if let data = value as? Data {
            write(data: data, for: forKey)
        } else {
            fatalError("Could not write \(value) to disk")
        }
    }
    
    public func string(forKey: String) -> String? {
        guard let d = data(forKey: forKey) else {
            return nil
        }
        return String(data: d, encoding: .utf8)
    }
    
    public func removeObject(forKey: String) {
        let url = self.url(for: forKey)
        if fileManager.fileExists(at: url) {
            try? fileManager.removeItem(at: url)
        }
    }
    
    public func double(forKey: String) -> Double {
        return 0
    }
    
    
}
