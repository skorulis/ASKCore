//  Created by Alexander Skorulis on 27/6/2022.

import SwiftUI
@preconcurrency import Knit

public struct ResolverKey: EnvironmentKey {
    public static let defaultValue: Resolver? = nil
}

public extension EnvironmentValues {
    
    var resolver: Resolver? {
        get { self[ResolverKey.self] }
        set { self[ResolverKey.self] = newValue }
    }
}
