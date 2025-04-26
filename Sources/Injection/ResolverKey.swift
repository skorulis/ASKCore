//  Created by Alexander Skorulis on 27/6/2022.

import SwiftUI
import Knit

public struct ResolverKey: EnvironmentKey {
    public static var defaultValue: Resolver?
}

public extension EnvironmentValues {
    
    var resolver: Resolver? {
        get { self[ResolverKey.self] }
        set { self[ResolverKey.self] = newValue }
    }
}
