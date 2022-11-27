//  Created by Alexander Skorulis on 27/11/2022.

import Foundation

public protocol PAnalyticsEvent {
    
    var name: String { get }
    var properties: [String: String] { get }
}
