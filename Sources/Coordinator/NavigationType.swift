//  Created by Alexander Skorulis on 6/11/2022.

import Foundation
import SwiftUI

/// How this was presented
public enum NavigationType {
    
    case push
    case present
    
    func dismiss() {
        
    }
    
}

public struct NavigationTypeKey: EnvironmentKey {
    public static var defaultValue: NavigationType? = nil
}

public extension EnvironmentValues {
    
    var navigationType: NavigationType? {
        get { self[NavigationTypeKey.self] }
        set { self[NavigationTypeKey.self] = newValue }
    }
}


