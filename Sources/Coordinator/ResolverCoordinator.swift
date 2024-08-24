//  Created by Alexander Skorulis on 24/8/2024.

import Combine
import Foundation
import SwiftUI
import Swinject

public final class ResolverCoordinator: PCoordinator, ObservableObject {
    
    @Published public var navPath = NavigationPath()
    @Published public var presented: PresentedCoordinator<ResolverCoordinator>?
    @Published public var shouldDismiss: Bool = false
    public var analytics: PAnalyticsService?
    public let root: PathWrapper
    let resolver: Resolver
    
    public init(root: any CoordinatorPath, resolver: Resolver) {
        self.root = PathWrapper(path: root, navigation: nil)
        self.resolver = resolver
    }
    
    public init(root: PathWrapper, resolver: Resolver) {
        self.root = root
        self.resolver = resolver
    }
    
    public func child(path: PathWrapper) -> ResolverCoordinator {
        let child = ResolverCoordinator(root: path, resolver: resolver)
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
    
    @MainActor
    public func make<Service>(_ block: @MainActor (Resolver) -> Service) -> Service {
        let service = block(resolver)
        (service as? ResolverCoordinatorViewModel)?.coordinator = self
        return service
    }
}

@MainActor
open class ResolverCoordinatorViewModel {
    public weak var coordinator: ResolverCoordinator! {
        didSet {
            onCoordinatorSet()
        }
    }
    
    public init() {}
    public var subscribers: Set<AnyCancellable> = []
    
    public func back() {
        coordinator.pop()
    }
    
    public func dismiss() {
        coordinator.shouldDismiss = true
    }
    
    public func dismiss(navType: NavigationType) {
        switch navType {
        case .push:
            coordinator.popToRoot()
        case .present:
            dismiss()
        }
    }
    
    open func onCoordinatorSet() { /* Overridden in children */ }
    
}

