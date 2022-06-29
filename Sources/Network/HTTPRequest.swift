//  Created by Alexander Skorulis on 29/6/2022.

import Foundation

public protocol HTTPRequest {
    
    associatedtype ResponseType
    
    var endpoint: String { get }
    var method: String { get }
    var body: Data? { get }
    var headers: [String: String] { get }
    var params: [String: String] { get }
    func decode(data: Data, response: URLResponse) throws -> ResponseType
    
}
