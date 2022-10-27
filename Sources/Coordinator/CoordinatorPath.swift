//  Created by Alexander Skorulis on 27/10/2022.

import Foundation
import SwiftUI

/*@available(iOS 16, *)
public protocol CoordinatorPath: Hashable {
    associatedtype CoordinatorType: PCoordinator //where CoordinatorType.PathType == Self
    associatedtype ViewType: View
    
    func render(coordinator: CoordinatorType) -> ViewType
    
    var id: String { get }
}*/

public protocol CoordinatorPath {
    
    func render(in coordinator: any PCoordinator) -> AnyView
    
    var id: String { get }
}

public protocol BoundCoordinatorPath: CoordinatorPath {
    associatedtype CoordinatorType: PCoordinator
    associatedtype ViewType: View
    
    func render(coordinator: CoordinatorType) -> ViewType
}

extension BoundCoordinatorPath {
    
    public func render(in coordinator: any PCoordinator) -> AnyView {
        guard let typedCoord = coordinator as? CoordinatorType else {
            fatalError("Incorrect coordinator type")
        }
        return AnyView(render(coordinator: typedCoord))
    }
    
}

struct PathWrapper: Hashable {
    
    private let path: any CoordinatorPath
    
    init(path: any CoordinatorPath) {
        self.path = path
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path.id)
    }
    
    static func == (lhs: PathWrapper, rhs: PathWrapper) -> Bool {
        return lhs.path.id == rhs.path.id
    }
    
    func render(coordinator: any PCoordinator) -> some View {
        return path.render(in: coordinator)
    }
    
}
