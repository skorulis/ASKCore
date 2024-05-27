//  Created by Alexander Skorulis on 26/5/2024.

import Foundation
import Swinject

public struct MainActorContainer {
    
    private let container: Container
    private let mainRegistrations: MainRegistrationStore
    
    init(container: Container) {
        self.container = container
        mainRegistrations = Self.resolveOrCreateMainStore(container: container)
    }
    
    private static func resolveOrCreateMainStore(container: Container) -> MainRegistrationStore {
        if let mainStore = container.resolve(MainRegistrationStore.self) {
            return mainStore
        }
        let mainStore = MainRegistrationStore()
        container.register(MainRegistrationStore.self) { _ in mainStore }
        return mainStore
    }
    
    private func registerMainError<Service>(_ service: Service.Type) {
        container.register(Service.self) { _ in
            fatalError("\(service) must be resolved via main.resolve()")
        }
        mainRegistrations.mainServices.insert(ObjectIdentifier(Service.self))
    }
    
    @discardableResult
    public func register<Service>(
        _ service: Service.Type,
        name: String? = nil,
        factory: @escaping @MainActor (Resolver) -> Service
    ) -> ServiceEntry<MainActorWrapper<Service>> {
        registerMainError(service)
        return container.register(MainActorWrapper<Service>.self, name: name, factory: { res in
            let filled: @MainActor () -> Service = {
                factory(res)
            }
            return MainActorWrapper<Service>(initializer: filled)
        })
    }
    
    @discardableResult
    public func register<Service, each Argument>(
        _ service: Service.Type,
        name: String? = nil,
        factory: @escaping @MainActor (Resolver, repeat each Argument) -> Service
    ) -> ServiceEntry<MainActorWrapperArguments<Service, repeat each Argument>> {
        registerMainError(service)
        return container.register(MainActorWrapperArguments<Service, repeat each Argument>.self, name: name, factory: { res in
            return MainActorWrapperArguments<Service, repeat each Argument> { (arguments: repeat each Argument) in
                factory(res, repeat each arguments)
            }
        })
    }
    
    var resolver: MainActorResolver {
        MainActorResolver(baseResolver: container)
    }
}

extension Container {
    public var main: MainActorContainer {
        return MainActorContainer(container: self)
    }
}

public final class MainActorWrapper<ServiceType> {
    
    var cache: ServiceType?
    let initializer: @MainActor () -> ServiceType
    
    init(initializer: @escaping @MainActor () -> ServiceType) {
        self.initializer = initializer
    }
}

public final class MainActorWrapperArguments<ServiceType, each Argument> {
    
    var cache: ServiceType?
    let initializer: @MainActor (repeat each Argument) -> ServiceType
    
    init(initializer: @escaping @MainActor (repeat each Argument) -> ServiceType) {
        self.initializer = initializer
    }
}
