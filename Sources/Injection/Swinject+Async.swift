//  Created by Alexander Skorulis on 28/3/2023.

import Foundation
import Swinject

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
            fatalError("\(service) must be resolved via main.resolve()")
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
    func registerMain<Service, Arg1>(
        _ service: Service.Type,
        name: String? = nil,
        factory: @escaping @MainActor (Resolver, Arg1) -> Service
    ) -> ServiceEntry<MainActorWrapper<Service>> {
        registerMainError(service)
        return self.register(MainActorWrapper<Service>.self, name: name, factory: { res, arg1 in
            let filled: @MainActor () -> Service = {
                factory(res, arg1)
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
                    res.main.resolve(A.self)!
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
                    res.main.resolve(A.self)!,
                    res.main.resolve(B.self)!
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
                    res.main.resolve(A.self)!,
                    res.main.resolve(B.self)!,
                    res.main.resolve(C.self)!
                )
            }
            return MainActorWrapper<Service>(initializer: filled)
        })
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

public struct MainActorResolver: Resolver {
    
    let baseResolver: Resolver
    
    @MainActor
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        guard let wrapper = baseResolver.resolve(MainActorWrapper<Service>.self) else {
            return baseResolver.resolve(Service.self)
        }
        
        if let cache = wrapper.cache {
            return cache
        }
        let created = wrapper.initializer()
        wrapper.cache = created
        return created
    }
    
    @MainActor
    public func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        fatalError()
    }
    
    @MainActor
    public func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service? {
        fatalError()
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
