//  Created by Alexander Skorulis on 5/2/2023.

import Foundation
import Knit

// @knit public
public struct ASKCoreAssembly: AutoInitModuleAssembly {
    public typealias TargetResolver = Resolver

    private let purpose: IOCPurpose
    
    public init() {
        self.purpose = .testing
    }
    
    public init(purpose: IOCPurpose) {
        self.purpose = purpose
    }
    
    public func assemble(container: Container<Resolver>) {
        container.register(IOCPurpose.self) { _ in
            return purpose
        }
        
        container.register(PKeyValueStore.self) { _ in
            switch purpose {
            case .normal:
                return UserDefaults.standard
            case .testing:
                return InMemoryDefaults()
            }
        }
        .inObjectScope(.container)
    }
    
    
    public static var dependencies: [any Knit.ModuleAssembly.Type] = []
    
}
