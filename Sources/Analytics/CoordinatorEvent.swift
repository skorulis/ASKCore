//  Created by Alexander Skorulis on 27/11/2022.

import Foundation

enum CoordinatorEvent: PAnalyticsEvent {
    
    case push(_ path: CoordinatorPath)
    case present(_ path: CoordinatorPath)
    
    var properties: [String: String] {
        switch self {
        case .push(let path), .present(let path):
            let name = (path as? AnalyticsCoordinatorPath)?.pathName ?? path.id
            return ["path": name]
        }
    }
    
    var name: String {
        switch self {
        case .push: return "push"
        case .present: return "present"
        }
    }
}
