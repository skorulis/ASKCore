//  Created by Alexander Skorulis on 27/10/2022.

import Foundation
import SwiftUI

public final class StandardCoordinator: PCoordinator, ObservableObject {
    
    @Published public var navPath = NavigationPath()
    @Published public var presented: PresentedCoordinator<StandardCoordinator>?
    @Published public var shouldDismiss: Bool = false
    public var analytics: PAnalyticsService?
    public let root: PathWrapper
    let factory: PFactory
    
    public init(root: any CoordinatorPath, factory: PFactory) {
        self.root = PathWrapper(path: root, navigation: nil)
        self.factory = factory
    }
    
    public init(root: PathWrapper, factory: PFactory) {
        self.root = root
        self.factory = factory
    }
    
    public func child(path: PathWrapper) -> StandardCoordinator {
        let child = StandardCoordinator(root: path, factory: factory)
        child.analytics = self.analytics
        return child
    }
    
    public func push(_ p: any CoordinatorPath) {
        analytics?.log(event: CoordinatorEvent.push(p))
        navPath.append(PathWrapper(path: p, navigation: .push))
    }
    
    public func pop() {
        guard !navPath.isEmpty else { return }
        navPath.removeLast()
    }
    
    public func present(_ path: any CoordinatorPath, style: PresentationStyle) {
        let wrapper = PathWrapper(path: path, navigation: .present)
        analytics?.log(event: CoordinatorEvent.present(path))
        let coordinator = child(path: wrapper)
        self.presented = PresentedCoordinator(coordinator: coordinator, style: style)
    }
    
}

extension StandardCoordinator: PFactory {
    
    @MainActor
    public func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        let obj = factory.resolve(serviceType, argument: argument)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
    @MainActor
    public func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        let obj = factory.resolve(serviceType, arguments: arg1, arg2)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
    @MainActor
    public func resolve<Service>(_ serviceType: Service.Type) -> Service {
        let obj = factory.resolve(serviceType)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
    @MainActor
    public func resolveMain<Service>(_ serviceType: Service.Type) -> Service {
        let obj = factory.resolveMain(serviceType)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
    @MainActor
    public func resolveMain<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        let obj = factory.resolveMain(serviceType, argument: argument)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
}
