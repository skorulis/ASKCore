//  Created by Alexander Skorulis on 26/5/2024.

import Foundation

final class MainRegistrationStore {
    
    internal var mainServices: Set<ObjectIdentifier> = []
    
    func isMainType<Service>(_ service: Service.Type = Service.self) -> Bool{
        return mainServices.contains(ObjectIdentifier(service))
    }
}
