//  Created by Alexander Skorulis on 27/6/2022.

import SwiftUI

public struct FactoryKey: EnvironmentKey {
    public static var defaultValue: PFactory = NullFactory()
}

public extension EnvironmentValues {
    
    var factory: PFactory {
        get { self[FactoryKey.self] }
        set { self[FactoryKey.self] = newValue }
    }
}

