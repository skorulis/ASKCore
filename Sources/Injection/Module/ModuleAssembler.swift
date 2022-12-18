//  Created by Alexander Skorulis on 17/12/2022.

import Foundation
import Swinject

public final class ModuleAssembler {
    
    let assembler: Assembler
    public var resolver: Resolver { assembler.resolver }
    
    public init(container: Container = Container(), modules: [any ModuleAssembly]) {
        let builder = DependencyBuilder(modules: modules)
        
        self.assembler = Assembler(container: container)
        assembler.apply(assemblies: builder.assemblies)
    }
    
    public convenience init(container: Container = Container(), moduleType: AutoModuleAssembly.Type) {
        let module = moduleType.init()
        self.init(container: container, modules: [module])
    }
    
}

private final class DependencyBuilder {
    
    private var inputModules: [any ModuleAssembly] = []
    var assemblies: [any ModuleAssembly] = []
    
    init(modules: [any ModuleAssembly]) {
        inputModules = modules
        for mod in modules {
            buildTree(module: mod)
        }
    }
    
    func buildTree(module: ModuleAssembly) {
        let deps = type(of: module).dependencies
        for dep in deps {
            if contains(module: dep) {
                continue
            }
            guard let autoType = dep as? AutoModuleAssembly.Type else {
                fatalError("Found non auto dependency: \(dep) that is not already registered")
            }
            buildTree(module: autoType.init())
        }
        assemblies.append(module)
    }
    
    func contains(module: ModuleAssembly.Type) -> Bool {
        let allModules = assemblies + inputModules
        return allModules.contains { mod in
            if type(of: mod) == module {
                return true
            }
            if module is AbstractModuleAssembly.Type,
               let impl = mod as? ConcreteModuleAssembly,
               type(of: impl).implements == module
            {
                return true
            }
            return false
        }
    }
    
}
