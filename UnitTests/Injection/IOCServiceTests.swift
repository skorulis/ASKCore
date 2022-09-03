//  Created by Alexander Skorulis on 16/5/21.

import Foundation
import XCTest
@testable import ASKCore

final class IOCServiceTests: XCTestCase {
    
    private let sut = IOCService(purpose: .testing)
    
    func test_factory() {
        _ = sut.factory // Nothing to test
    }
}
