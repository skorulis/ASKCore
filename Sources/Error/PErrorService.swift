//  Created by Alexander Skorulis on 1/7/2022.

import Foundation

public protocol PErrorService {
    
    func handle(error: Error)
}
