//  Created by Alexander Skorulis on 27/6/2022.

import SwiftUI
import Knit

public struct FactoryKey: EnvironmentKey {
    public static var defaultValue: PFactory = NullFactory()
}

public extension EnvironmentValues {
    
    var factory: PFactory {
        get { self[FactoryKey.self] }
        set { self[FactoryKey.self] = newValue }
    }
}

public struct ResolverKey: EnvironmentKey {
    public static var defaultValue: Resolver = Container()
}

public extension EnvironmentValues {
    
    var resolver: Resolver {
        get { self[ResolverKey.self] }
        set { self[ResolverKey.self] = newValue }
    }
}
