//  Created by Alexander Skorulis on 26/5/2024.

import Foundation
import Swinject

public struct MainActorResolver: Resolver {
    
    private let baseResolver: Resolver
    private let mainRegistrations: MainRegistrationStore
    
    init(baseResolver: Resolver) {
        self.baseResolver = baseResolver
        guard let mainStore = baseResolver.resolve(MainRegistrationStore.self) else {
            fatalError("MainRegistrationStore must be registered to use main actor resolvers")
        }
        mainRegistrations = mainStore
    }
    
    @MainActor
    public func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        guard mainRegistrations.isMainType(serviceType) else {
            return baseResolver.resolve(Service.self)
        }
        guard let wrapper = baseResolver.resolve(MainActorWrapper<Service>.self) else {
            fatalError("\(serviceType) must be resolved via main.resolve()")
        }
        
        if let cache = wrapper.cache {
            return cache
        }
        let created = wrapper.initializer()
        wrapper.cache = created
        return created
    }
    
    @MainActor
    public func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service? {
        guard mainRegistrations.isMainType(serviceType) else {
            return baseResolver.resolve(Service.self)
        }
        guard let wrapper = baseResolver.resolve(MainActorWrapper<Service>.self) else {
            fatalError("\(serviceType) must be resolved via main.resolve()")
        }
        return wrapper.initializer(argument)
    }
    
    @MainActor
    public func resolve<Service, Arg1>(_ serviceType: Service.Type, name: String?, argument: Arg1) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) -> Service? {
        fatalError()
    }
}

extension MainActorResolver {
    
    @MainActor
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return resolve(serviceType, name: nil)
    }
}

public extension Resolver {
    var main: MainActorResolver {
        if let selfMain = self as? MainActorResolver {
            return selfMain
        }
        return MainActorResolver(baseResolver: self)
    }
}
