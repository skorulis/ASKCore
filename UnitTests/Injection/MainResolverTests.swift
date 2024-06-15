//  Created by Alexander Skorulis on 25/5/2024.

@testable import ASKCore
import Foundation
import Swinject
import XCTest

final class MainResolverTests: XCTestCase {
    
    private let mainStore = MainRegistrationStore()
    private lazy var container: Container = {
        let container = Container()
        container.register(MainRegistrationStore.self) { _ in self.mainStore }
        return container
    }()
    
    
    @MainActor
    func test_register_main() {
        container.main.register(Service1.self) { _ in Service1() }
        XCTAssertNotNil(container.main.resolve(Service1.self))
    }
    
    @MainActor
    func test_resolve_non_main() {
        container.register(Service3.self) { _ in Service3() }
        XCTAssertNotNil(container.main.resolve(Service3.self))
    }
    
    @MainActor
    func test_register_main_complex() {
        container.main.register(Service1.self) { _ in Service1() }
        container.register(Service3.self) { _ in Service3() }
        container.main.register(Service2.self) { r in
            Service2(
                service1: r.main.resolve(Service1.self)!,
                service3: r.main.resolve(Service3.self)!
            )
        }
        XCTAssertNotNil(container.resolve(Service3.self))
        XCTAssertNotNil(container.main.resolve(Service2.self))
    }
    
    @MainActor
    func test_register_main_argument() {
        container.main.register(Service4.self) { resolver, arg1 in
            Service4(id: arg1)
        }
        XCTAssertNotNil(container.main.resolve(Service4.self, arguments: "Test"))
    }
}

@MainActor
private struct Service1 {}

@MainActor
private struct Service2 {
    let service1: Service1
    let service3: Service3
}

private struct Service3 {}

private struct Service4 {
    let id: String
}
