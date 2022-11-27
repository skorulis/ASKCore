//  Created by Alexander Skorulis on 27/11/2022.

import Foundation

public protocol PAnalyticsService {
    
    func log(event: String)
    func log(event: PAnalyticsEvent)
    
}
