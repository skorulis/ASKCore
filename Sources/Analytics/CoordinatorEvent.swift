//  Created by Alexander Skorulis on 27/11/2022.

import Foundation

enum CoordinatorEvent: PAnalyticsEvent {
    
    case push(_ path: CoordinatorPath)
    
    var properties: [String: String] {
        switch self {
        case .push(let path):
            return ["path": path.id]
        }
    }
    
    
    var name: String {
        switch self {
        case .push: return "push"
        }
    }
}
