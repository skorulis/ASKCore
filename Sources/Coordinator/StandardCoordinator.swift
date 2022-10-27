//  Created by Alexander Skorulis on 27/10/2022.

import Foundation
import SwiftUI

public final class StandardCoordinator: PCoordinator, ObservableObject {
    
    @Published public var navPath = NavigationPath()
    @Published public var presented: PresentedCoordinator<StandardCoordinator>?
    @Published public var shouldDismiss: Bool = false
    public let root: any CoordinatorPath
    let factory: PFactory
    
    public init(root: any CoordinatorPath, factory: PFactory) {
        self.root = root
        self.factory = factory
    }
    
    public func child(path: CoordinatorPath) -> StandardCoordinator {
        return StandardCoordinator(root: path, factory: factory)
    }
    
}

extension StandardCoordinator: PFactory {
    
    public func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        let obj = factory.resolve(serviceType, argument: argument)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
    public func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        let obj = factory.resolve(serviceType, arguments: arg1, arg2)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service {
        let obj = factory.resolve(serviceType)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
}
