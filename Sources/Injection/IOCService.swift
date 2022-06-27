//
//  IOC.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import Swinject
import SwinjectAutoregistration

open class IOCService: PContainerFactory {
    
    public let container: Container
    
    public init() {
        container = Container()
        
        container.register(GenericFactory.self) { [unowned self] res in
            return GenericFactory(container: self.container)
        }
    }
    
    public var factory: GenericFactory {
        return resolve(GenericFactory.self)
    }
    
}
