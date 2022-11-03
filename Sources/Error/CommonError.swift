//  Created by Alexander Skorulis on 3/11/2022.

import Foundation

public enum CommonError: Error, LocalizedError {
    
    case generic(_ message: String)
    
    public var errorDescription: String? {
        switch self {
        case .generic(let message):
            return message
        }
    }
    
}
