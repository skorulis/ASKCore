//  Created by Alexander Skorulis on 29/10/2022.

import Foundation
import Combine

public final class ErrorService: PErrorService {
    
    public let errorPublisher: PassthroughSubject<[IdentifiedError], Never> = .init()
    
    public init() {}
    
    @Published public var errorQueue: [IdentifiedError] = [] {
        didSet {
            errorPublisher.send(errorQueue)
        }
    }
    
    public func handle(error: Error) {
        if let idError = error as? IdentifiedError {
            errorQueue.append(idError)
        } else {
            errorQueue.append(IdentifiedError(error: error))
        }
    }
    
    public func finish(error: IdentifiedError) {
        errorQueue = errorQueue.filter { $0.id != error.id }
    }
    
}
