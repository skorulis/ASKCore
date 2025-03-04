//  Created by Alexander Skorulis on 28/8/21.

import Foundation
import Knit

open class IOCService: PContainerFactory {
    
    public let container: Container
    public let purpose: IOCPurpose
    
    @MainActor
    public init(purpose: IOCPurpose) {
        container = Container()
        CoreModuleAssembly(purpose: purpose).assemble(container: container)
        self.purpose = purpose
        
        let fac = container.register(GenericFactory.self) { [unowned self] res in
            return GenericFactory(container: self.container)
        }
        container.forward(PFactory.self, to: fac)
        
        container.register(PErrorService.self) { _ in ErrorService() }
            .inObjectScope(.container)
#if canImport(UIKit)
        container.register(ErrorPresentationManager.self) { resolver in 
            ErrorPresentationManager(errorService: resolver.resolve(PErrorService.self)!)
        }
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
