//  Created by Alexander Skorulis on 5/2/2023.

import Foundation
import Swinject

public struct CoreModuleAssembly: Assembly {

    private let purpose: IOCPurpose
    
    public init() {
        self.purpose = .testing
    }
    
    public init(purpose: IOCPurpose) {
        self.purpose = purpose
    }
    
    public func assemble(container: Container) {
        container.register(IOCPurpose.self) { _ in
            return purpose
        }
        container.register(GenericFactory.self) { res in
            return GenericFactory(container: container)
        }
        .implements(PFactory.self)
    }
    
    
}
