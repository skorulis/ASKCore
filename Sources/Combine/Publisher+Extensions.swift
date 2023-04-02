//  Created by Alexander Skorulis on 16/9/2022.

import Combine
import Foundation

public extension Publisher {
    
    func delayedChange() -> Publishers.Debounce<Self, DispatchQueue> {
        debounce(for: .zero, scheduler: .main)
    }
    
    
}

public extension Publisher where Failure == Error {
    
    // Sink version giving a single result
    func sink(result: @escaping (Result<Self.Output, Self.Failure>) -> Void) -> AnyCancellable {
        sink { completion in
            switch completion {
            case .finished:
                break // Use value from receiveValue
            case let .failure(error):
                result(.failure(error))
            }
        } receiveValue: { value in
            result(.success(value))
        }
    }
    
    
}
