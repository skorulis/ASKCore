//  Created by Alexander Skorulis on 27/10/2022.

import Combine
import Foundation

public protocol PCoordinatedViewModel: AnyObject {
    var coordinator: StandardCoordinator! {get set}
    var subscribers: Set<AnyCancellable> {get set}
}

open class CoordinatedViewModel: PCoordinatedViewModel {
    public weak var coordinator: StandardCoordinator! {
        didSet {
            onCoordinatorSet()
        }
    }
    
    public init() {
        
    }
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

