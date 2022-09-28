//  Created by Alexander Skorulis on 28/9/2022.

import Foundation

// MARK: - Memory footprint

public final class ValidatedString: ObservableObject {
    
    private let validator: any StringValidator
    
    @Published public var string: String {
        didSet {
            let valid = validator.validate(string)
            switch valid {
            case .valid:
                break
            case .invalid:
                string = oldValue
            }
        }
    }
    
    public init(validator: any StringValidator, string: String = "") {
        self.validator = validator
        self.string = string
    }
    
}
