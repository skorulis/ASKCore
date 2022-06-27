//  Created by Alexander Skorulis on 27/6/2022.

import Foundation

public protocol PFactory {
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service
    func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service
    
    func resolve<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2
    ) -> Service
}

public extension PFactory {
    
    func resolve<Service>() -> Service {
        return self.resolve(Service.self)
    }
}
