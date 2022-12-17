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

public protocol AutoModuleAssembly: ModuleAssembly {
    init()
}
