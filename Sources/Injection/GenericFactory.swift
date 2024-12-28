//  Created by Alexander Skorulis on 16/5/21.

import Knit
import Foundation

public final class GenericFactory: PContainerFactory {    
    
    public let container: Container
    
    init() {
        self.container = Container()
    }
    
    public init(container: Container) {
        self.container = container
    }
    
}
