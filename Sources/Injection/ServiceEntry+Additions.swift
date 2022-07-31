//  Created by Alexander Skorulis on 31/7/2022.

import Foundation
import Swinject

extension ServiceEntry {
    
    @discardableResult
    public func forward<T>(from: T.Type, container: Container) -> Self {
        container.forward(T.self, to: self)
        return self
    }
}
