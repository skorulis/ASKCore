//
//  IOC.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import Swinject
import SwinjectAutoregistration

open class IOCService: PContainerFactory {
    
    public let container: Container
    public let purpose: IOCPurpose
    
    public init(purpose: IOCPurpose) {
        container = Container()
        self.purpose = purpose
        
        let fac = container.register(GenericFactory.self) { [unowned self] res in
            return GenericFactory(container: self.container)
        }
        container.forward(PFactory.self, to: fac)
        
        container.autoregister(ModuleRegistrationService.self, initializer: ModuleRegistrationService.init)
            .inObjectScope(.container)
        
        container.autoregister(PErrorService.self, initializer: ErrorService.init)
            .inObjectScope(.container)
        container.autoregister(ErrorPresentationManager.self, initializer: ErrorPresentationManager.init)
    }
    
    public var factory: GenericFactory {
        return resolve(GenericFactory.self)
    }
    
}
