//  Created by Alexander Skorulis on 1/7/2022.

import Foundation

public struct LogErrorService: PErrorService {
    
    public init() {}
    
    public func handle(error: Error) {
        print(error)
    }
    
}
