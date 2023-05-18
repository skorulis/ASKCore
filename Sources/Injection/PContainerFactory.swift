//  Created by Alexander Skorulis on 27/6/2022.

import Foundation
import Swinject

/// A factory implemented by having a container
public protocol PContainerFactory: PFactory {
    
    var container: Container { get }
    
}

public extension PContainerFactory {
    
    func resolve<Service>(_ serviceType: Service.Type = Service.self) -> Service {
        guard let service = container.resolve(serviceType) else {
            fatalError("Could not resolve \(serviceType)")
        }
        return service
    }
    
    func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        guard let service = container.resolve(serviceType, argument: argument) else {
            fatalError("Could not resolve \(serviceType)")
        }
        return service
    }
    
    func resolve<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2
    ) -> Service {
        guard let service = container.resolve(serviceType, arguments: arg1, arg2) else {
            fatalError("Could not resolve \(serviceType)")
        }
        return service
    }
    
    @MainActor
    func resolveMain<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = container.resolveMain(serviceType) else {
            fatalError("Could not resolve \(serviceType)")
        }
        return service
    }
    
}
