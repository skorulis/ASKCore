//  Created by Alexander Skorulis on 28/8/21.

import Foundation
import Swinject

open class IOCService: PContainerFactory {
    
    public let container: Container
    public let purpose: IOCPurpose
    
    public init(purpose: IOCPurpose) {
        container = Container()
        self.purpose = purpose
        container.register(IOCPurpose.self) { _ in
            return purpose
        }
        
        let fac = container.register(GenericFactory.self) { [unowned self] res in
            return GenericFactory(container: self.container)
        }
        container.forward(PFactory.self, to: fac)
        
        container.register(PErrorService.self) { _ in ErrorService() }
            .inObjectScope(.container)
#if canImport(UIKit)
        container.autoregister(ErrorPresentationManager.self, initializer: ErrorPresentationManager.init)
#endif
    }
    
    public var factory: GenericFactory {
        return resolve(GenericFactory.self)
    }
    
}

public extension Container {
    
    var purpose: IOCPurpose {
        return self.resolve(IOCPurpose.self) ?? .testing
    }
}
