//  Created by Alexander Skorulis on 27/7/2022.

import Foundation
import SwiftUI

@available(iOS 16, *)
public protocol CoordinatorPath: Hashable {
    associatedtype CoordinatorType: PCoordinator where CoordinatorType.PathType == Self
    associatedtype ViewType: View
    
    func render(coordinator: CoordinatorType) -> ViewType
    
    var id: String { get }
}

@available(iOS 16, *)
public protocol PCoordinator: ObservableObject {
    associatedtype PathType: CoordinatorPath where PathType.CoordinatorType == Self
    
    var navPath: NavigationPath { get set }
    var presented: PresentedCoordinator<Self>? { get set }
    var shouldDismiss: Bool { get set }
    var root: PathType { get }
    
    /// Create a child coordinator for presentation
    func child(path: PathType) -> Self
    
}

@available(iOS 16, *)
public extension PCoordinator {
    
    func push(_ p: PathType) {
        navPath.append(p)
    }
    
    func pop() {
        navPath.removeLast()
    }
    
    func present(_ path: PathType, style: PresentationStyle) {
        let coordinator = child(path: path)
        self.presented = PresentedCoordinator(coordinator: coordinator, style: style)
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
