//  Created by Alex Skorulis on 1/4/2026.

import Foundation
import Knit
import XCTest
@testable import ASKCore

final class ASKCoreAssemblyTests: XCTestCase {
    
    @MainActor
    func test_resolution() {
        let assembler = ScopedModuleAssembler<Resolver>([ASKCoreAssembly()])
        
        XCTAssertTrue(assembler.resolver.isAvailable)
        let keyValueStore = assembler.resolver.pKeyValueStore()
        XCTAssertTrue(keyValueStore is InMemoryKeyValueStore)
        let secureStore = assembler.resolver.secureKeyValueStore()
        XCTAssertTrue(secureStore is InMemoryKeyValueStore)
    }
}

