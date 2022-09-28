//  Created by Alexander Skorulis on 28/9/2022.

import Foundation

/// Allows validating any kind of input
public protocol Validator {
    associatedtype InputType
    
    func validate(_ input: InputType) -> ValidationResult
}

/// Validator type for strings
public protocol StringValidator: Validator where InputType == String {
    
}

protocol ValidationError: Error {
    
    /// Should this error block text entry
    var blocking: Bool { get }
    
}

public enum ValidationResult {
    /// Text is allowed
    case valid
    
    /// Text is not currently valid
    case invalid
    
    var isValid: Bool {
        return self == .valid
    }
}
