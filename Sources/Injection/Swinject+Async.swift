//  Created by Alexander Skorulis on 28/3/2023.

import Foundation
import Swinject
 
public extension Container {
    
    private func registerMainError<Service>(_ service: Service.Type) {
        register(Service.self) { _ in
            fatalError("\(service) must be resolved via main.resolve()")
        }
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
