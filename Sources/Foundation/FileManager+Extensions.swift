//  Created by Alexander Skorulis on 8/1/2023.

import Foundation

public extension FileManager {
    
    func fileExists(at url: URL) -> Bool {
        let path = url.pathComponents.joined(separator: "/")
        return fileExists(atPath: path)
    }
    
}
