//  Created by Alexander Skorulis on 16/5/21.

import Swinject
import Foundation

final class GenericFactory: PContainerFactory {
    
    public let container: Container
    
    init() {
        self.container = Container()
    }
    
    init(container: Container) {
        self.container = container
    }
    
}
