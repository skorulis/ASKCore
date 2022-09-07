//  Created by Alexander Skorulis on 3/9/2022.

import Foundation
import Swinject

public protocol PModule {
    
    init()
    func register(container: Container, purpose: IOCPurpose)
    static var dependencies: [PModule.Type] { get }
    
}

public extension PModule {
    
    static func ioc(purpose: IOCPurpose = .testing, adjust: (Container) -> Void = {_ in }) -> IOCService {
        let ioc = IOCService(purpose: purpose)
        let registration = ioc.resolve(ModuleRegistrationService.self)
        registration.register(container: ioc.container,
                              purpose: purpose,
                              module: self)
        adjust(ioc.container)
        return ioc
    }
    
}
