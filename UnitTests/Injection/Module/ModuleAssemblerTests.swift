//  Created by Alexander Skorulis on 17/12/2022.

import Foundation
import XCTest
import Swinject
@testable import ASKCore

final class ModuleAssemblerTests: XCTestCase {
    
    func test_auto_assembler() {
        let resolver = Assembly1().assembled().resolver
        XCTAssertNotNil(resolver.resolve(Service1.self))
    }
    
    func test_non_auto_assembler() {
        let resolver = ModuleAssembler(modules: [
            Assembly3(),
            Assembly1()
        ]).resolver
        XCTAssertNotNil(resolver.resolve(Service1.self))
    }
    
    func test_abstract_assembly() {
        let resolver = ModuleAssembler(modules: [Assembly5(), Assembly6()]).resolver
        XCTAssertNotNil(resolver.resolve(Service3.self))
    }
}

private struct Assembly1: ModuleAssembly {
    
    static var dependencies: [ModuleAssembly.Type] {
        return [
            Assembly2.self
        ]
    }
    
    func assemble(container: Container) {
        container.register(Service1.self) { r in Service1.init(service2: r.resolve(Service2.self)!) }
    }
    
}

private struct Assembly2: AutoModuleAssembly {
 
    static var dependencies: [ModuleAssembly.Type] {
        return []
    }
    
    func assemble(container: Container) {
        container.register(Service2.self) { _ in Service2() }
    }
}

private struct Assembly3: ModuleAssembly {
    static var dependencies: [ModuleAssembly.Type] {
        return [Assembly1.self]
    }
    
    func assemble(container: Container) {
        
    }
}

private struct Assembly4: AbstractModuleAssembly {
    static var dependencies: [ASKCore.ModuleAssembly.Type] = []
}
private struct Assembly5: ConcreteModuleAssembly, AutoModuleAssembly {
    static let implements: any AbstractModuleAssembly.Type = Assembly4.self
    
    static var dependencies: [ModuleAssembly.Type] { [] }
    
    func assemble(container: Container) {
        container.register(Service3.self) { _ in Service3() }
    }
}

private struct Assembly6: AutoModuleAssembly {
    
    static var dependencies: [ModuleAssembly.Type] {
        return [Assembly4.self]
    }
    
    func assemble(container: Swinject.Container) {}
}

private struct Service1 {
    
    let service2: Service2
    
    init(service2: Service2) {
        self.service2 = service2
    }
    
}

private struct Service2 { }
private struct Service3 {}
