//  Created by Alexander Skorulis on 27/6/2022.

import Foundation

/// Factory which cannot resolve any objects. Used as a placeholder to prevent the need for options
public struct NullFactory: PFactory {
    public func resolve<Service>(_ serviceType: Service.Type) -> Service {
        fatalError("Cannot resolve from NullFactory")
    }
    
    public func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        fatalError("Cannot resolve from NullFactory")
    }
    
    public func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        fatalError("Cannot resolve from NullFactory")
    }
    
    @MainActor
    public func resolveMain<Service>(_ serviceType: Service.Type) -> Service {
        fatalError("Cannot resolve from NullFactory")
    }
    
}
