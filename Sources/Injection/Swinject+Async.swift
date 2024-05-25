//  Created by Alexander Skorulis on 28/3/2023.

import Foundation
import Swinject

public extension Resolver {
    
    @MainActor
    func resolveMain<Service>(_ service: Service.Type) -> Service? {
        guard let wrapper = self.resolve(MainActorWrapper<Service>.self) else {
            return self.resolve(Service.self)
        }
        
        if let cache = wrapper.cache {
            return cache
        }
        let created = wrapper.initializer()
        wrapper.cache = created
        return created
    }
    
    func resolveAsync<Service>(_ service: Service.Type) async -> Service? {
        return await resolveMain(service)
    }
    
}

public final class MainActorWrapper<ServiceType> {
    
    var cache: ServiceType?
    let initializer: @MainActor () -> ServiceType
    
    init(initializer: @escaping @MainActor () -> ServiceType) {
        self.initializer = initializer
    }
    
}
 
public extension Container {
    
    private func registerMainError<Service>(_ service: Service.Type) {
        register(Service.self) { _ in
            fatalError("\(service) must be resolved via resolveMain")
        }
    }
    
    @discardableResult
    func registerMain<Service>(
        _ service: Service.Type,
        name: String? = nil,
        factory: @escaping @MainActor (Resolver) -> Service
    ) -> ServiceEntry<MainActorWrapper<Service>> {
        registerMainError(service)
        return self.register(MainActorWrapper<Service>.self, name: name, factory: { res in
            let filled: @MainActor () -> Service = {
                factory(res)
            }
            return MainActorWrapper<Service>(initializer: filled)
        })
    }
    
    @discardableResult
    func autoregisterMain<Service>(_ service: Service.Type, name: String? = nil, initializer: @escaping @MainActor () -> Service) -> ServiceEntry<MainActorWrapper<Service>> {
        registerMainError(service)
        return self.register(MainActorWrapper<Service>.self, name: name, factory: { res in
           return MainActorWrapper<Service>(initializer: initializer)
        })
    }
    
    @discardableResult
    func autoregisterMain<Service, A>(_ service: Service.Type, name: String? = nil, initializer: @escaping @MainActor (A) -> Service) -> ServiceEntry<MainActorWrapper<Service>> {
        registerMainError(service)
        return self.register(MainActorWrapper<Service>.self, name: name, factory: { res in
            let filled: @MainActor () -> Service = {
                return initializer(
                    res.resolveMain(A.self)!
                )
            }
            return MainActorWrapper<Service>(initializer: filled)
        })
    }
    
    @discardableResult
    func autoregisterMain<Service, A, B>(_ service: Service.Type, name: String? = nil, initializer: @escaping @MainActor (A, B) -> Service) -> ServiceEntry<MainActorWrapper<Service>> {
        return self.register(MainActorWrapper<Service>.self, name: name, factory: { res in
            let filled: @MainActor () -> Service = {
                return initializer(
                    res.resolveMain(A.self)!,
                    res.resolveMain(B.self)!
                )
            }
            return MainActorWrapper<Service>(initializer: filled)
        })
    }
    
    @discardableResult
    func autoregisterMain<Service, A, B, C>(_ service: Service.Type, name: String? = nil, initializer: @escaping @MainActor (A, B, C) -> Service) -> ServiceEntry<MainActorWrapper<Service>> {
        return self.register(MainActorWrapper<Service>.self, name: name, factory: { res in
            let filled: @MainActor () -> Service = {
                return initializer(
                    res.resolveMain(A.self)!,
                    res.resolveMain(B.self)!,
                    res.resolveMain(C.self)!
                )
            }
            return MainActorWrapper<Service>(initializer: filled)
        })
    }
}
