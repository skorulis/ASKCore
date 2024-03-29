//  Created by Alexander Skorulis on 27/7/2022.

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@available(iOS 16, *)
public protocol PCoordinator: ObservableObject {
    // associatedtype PathType: CoordinatorPath where PathType.CoordinatorType == Self
    
    var navPath: NavigationPath { get set }
    var presented: PresentedCoordinator<Self>? { get set }
    var shouldDismiss: Bool { get set }
    var root: PathWrapper { get }
    
    /// Create a child coordinator for presentation
    func child(path: PathWrapper) -> Self
    
    func push(_ path: any CoordinatorPath)
    func pop()
    func present(_ path: any CoordinatorPath, style: PresentationStyle)
    
}

@available(iOS 16, *)
public extension PCoordinator {
    
    func popToRoot() {
        // Fix an error with the animation
        let animation = CATransition()
        animation.isRemovedOnCompletion = true
        animation.type = .moveIn
        animation.subtype = .fromLeft
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
#if canImport(UIKit)
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        keyWindow?.layer.add(animation, forKey: nil)
#endif
        navPath.removeLast(navPath.count)
    }
    
}

@available(iOS 16, *)
public struct PresentedCoordinator<T: PCoordinator>: Identifiable {
    
    public let coordinator: T
    public let style: PresentationStyle
    
    public var id: String {
        return coordinator.root.id
    }
    
    public init(coordinator: T, style: PresentationStyle) {
        self.coordinator = coordinator
        self.style = style
    }
    
    func only(style: PresentationStyle) -> Self? {
        switch (self.style, style) {
        case (.fullScreen, .fullScreen): return self
        case (.sheet, .sheet): return self
        default: return nil
        }
    }
    
}

public enum PresentationStyle {
    case fullScreen, sheet
}
