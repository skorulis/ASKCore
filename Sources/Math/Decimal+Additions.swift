//  Created by Alexander Skorulis on 4/10/2022.

import Foundation

public extension Decimal {
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
