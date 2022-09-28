//  Created by Alexander Skorulis on 28/9/2022.

import Foundation

/// Checks that only valid characters exist in the input string
public final class CharacterRegexValidator: StringValidator {
    
    private let regex: Regex<AnyRegexOutput>
    
    public init(string: String) throws {
        self.regex = try Regex(string)
    }
    
    public init(regex: Regex<AnyRegexOutput>) {
        self.regex = regex
    }
    
    public func validate(_ input: String) -> ValidationResult {
        let removed = input.replacing(regex, with: "")
        if removed.isEmpty {
            return .valid
        } else {
            return .invalid
        }
    }
    
}

public extension CharacterRegexValidator {
    
    static var positiveInteger: CharacterRegexValidator {
        return try! CharacterRegexValidator(string: "[0-9]")
    }
    
    static var positiveDouble: CharacterRegexValidator {
        return try! CharacterRegexValidator(string: "[0-9\\.]")
    }
    
}
