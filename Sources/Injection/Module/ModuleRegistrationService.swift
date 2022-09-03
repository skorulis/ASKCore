//  Created by Alexander Skorulis on 3/9/2022.

import Foundation
import Swinject

final class ModuleRegistrationService {
    
    private var registered: [any PModule] = []
    
    func register(container: Container, purpose: IOCPurpose, modules: [PModule.Type]) {
        for mod in modules {
            register(container: container, purpose: purpose, module: mod)
        }
    }
    
    func register(container: Container, purpose: IOCPurpose, module: PModule.Type) {
        let deps = module.dependencies
        for dep in deps {
            register(container: container, purpose: purpose, module: dep)
        }
        
        if existing(module: module) != nil {
            return
        }
        
        let instance = module.init()
        
        instance.register(container: container, purpose: purpose)
        registered.append(instance)
    }
    
    private func existing(module: PModule.Type) -> PModule? {
        for i in registered {
            if type(of: i) == module {
                return i
            }
        }
        return nil
    }
    
}
