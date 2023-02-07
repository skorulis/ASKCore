//  Created by Alexander Skorulis on 17/12/2022.

import Foundation
import Swinject

public protocol ModuleAssembly: Assembly {
    
    static var dependencies: [ModuleAssembly.Type] { get }
    
}

public extension ModuleAssembly {
    
    func assembled(container: Container = Container()) -> Assembler {
        let assembler = ModuleAssembler(container: container, modules: [self])
        return assembler.assembler
    }
}

/// A ModuleAssembly that can be automatically initialised
public protocol AutoModuleAssembly: ModuleAssembly {
    init()
}

/// A module that defines used services but does not implement them
public protocol AbstractModuleAssembly: ModuleAssembly {}

extension AbstractModuleAssembly {
    public func assemble(container: Container) {
        fatalError("Cannot assemble AbstractModuleAssembly")
    }
}

/// Provides the assembly implementation for an AbstractModuleAssembly
public protocol ConcreteModuleAssembly: ModuleAssembly {
    
    static var implements: AbstractModuleAssembly.Type { get }
    
}

public extension Assembler {
    var factory: PFactory {
        return resolver.resolve(PFactory.self)!
    }
}
