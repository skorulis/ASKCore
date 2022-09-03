//  Created by Alexander Skorulis on 3/9/2022.

import Foundation
import Swinject

public protocol PModule {
    
    init()
    func register(container: Container, purpose: IOCPurpose)
    var dependencies: [PModule.Type] { get }
    
}
