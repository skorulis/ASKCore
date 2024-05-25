//  Created by Alexander Skorulis on 25/5/2024.

import ASKCore
import Foundation
import Swinject
import XCTest

final class MainResolverTests: XCTestCase {
    
    let container = Container()
    
    @MainActor
    func test_register_main() {
        container.registerMain(Service1.self) { _ in Service1() }
        
        XCTAssertNotNil(container.resolveMain(Service1.self))
    }
}

@MainActor
private struct Service1 {
    
}
