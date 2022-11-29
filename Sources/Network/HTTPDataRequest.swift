//  Created by Alexander Skorulis on 29/11/2022.

import Foundation

public struct HTTPDataRequest: HTTPRequest {
    
    public var endpoint: String
    public var method: String = "GET"
    public var body: Data?
    public var headers: [String: String] = [:]
    public var params: [String: String] = [:]
    
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    public func decode(data: Data, response: URLResponse) throws -> Data {
        return data
    }
}
