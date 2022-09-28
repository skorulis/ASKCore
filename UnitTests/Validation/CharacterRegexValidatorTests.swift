//  Created by Alexander Skorulis on 28/9/2022.

import Foundation
import XCTest
@testable import ASKCore

@available(iOS 16, *)
final class CharacterRegexValidatorTests: XCTestCase {
    
    func test_integerMatching() throws {
        let validator = CharacterRegexValidator.positiveInteger
        XCTAssertTrue(validator.validate("123").isValid)
        XCTAssertTrue(validator.validate("0123456789").isValid)
        XCTAssertTrue(validator.validate("").isValid)
        
        XCTAssertFalse(validator.validate("-123").isValid)
        XCTAssertFalse(validator.validate("-123").isValid)
        XCTAssertFalse(validator.validate("ABC").isValid)
    }
    
    func test_postiveDouble() throws {
        let validator = CharacterRegexValidator.positiveDouble
        XCTAssertTrue(validator.validate("123").isValid)
        XCTAssertTrue(validator.validate("123.").isValid)
        XCTAssertTrue(validator.validate("123.7").isValid)
    }
    
}

