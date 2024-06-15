//  Created by Alexander Skorulis on 26/5/2024.

import Foundation
import Swinject

public struct MainActorResolver {
    
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
    public func resolve<Service, each Argument>(_ serviceType: Service.Type, arguments: repeat each Argument) -> Service? {
        return resolve(serviceType, name: nil, arguments: repeat each arguments)
    }
    
    @MainActor
    public func resolve<Service, each Argument>(_ serviceType: Service.Type, name: String?, arguments: repeat each Argument) -> Service? {
        guard mainRegistrations.isMainType(serviceType) else {
            return baseResolver.resolve(Service.self)
        }
        let type = MainActorWrapperArguments<Service, repeat each Argument>.self
        guard let wrapper: MainActorWrapperArguments<Service, repeat each Argument> = baseResolver.resolve(type) else {
            fatalError("\(serviceType) must be resolved via main.resolve()")
        }
        
        return wrapper.initializer(repeat each arguments)
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
