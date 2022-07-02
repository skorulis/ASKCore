//  Created by Alexander Skorulis on 1/7/2022.

import Foundation

public extension Task {
    
    @discardableResult
    func handleError(service: PErrorService) -> Task<Success, Error> {
        return Task<Success, Error> {
            let result = await self.result
            switch result {
            case .success(let value):
                return value
            case .failure(let error):
                _ = await Task<Void, Never> { @MainActor in
                    service.handle(error: error)
                }.result
                throw error
            }
        }
        
    }
}
