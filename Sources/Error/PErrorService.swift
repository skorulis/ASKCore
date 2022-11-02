//  Created by Alexander Skorulis on 1/7/2022.

import Combine
import Foundation

/// An error with a fixed ID
public struct IdentifiedError: Error, LocalizedError {
    
    public let error: Error
    public let id: String
    
    public init(error: Error, id: String = UUID().uuidString) {
        self.error = error
        self.id = id
    }
    
    public var errorDescription: String? {
        return error.localizedDescription
    }
}

public protocol PErrorService {

    var errorPublisher: PassthroughSubject<[IdentifiedError], Never> { get }
    
    /// Do something with an error that was raised
    func handle(error: Error)
    
    /// Call after an error has been handled
    func finish(error: IdentifiedError)
}

