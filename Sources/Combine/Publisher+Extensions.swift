//  Created by Alexander Skorulis on 16/9/2022.

import Combine
import Foundation

public extension Publisher {
    
    func delayedChange() -> Publishers.Debounce<Self, DispatchQueue> {
        debounce(for: .zero, scheduler: .main)
    }
}
