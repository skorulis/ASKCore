//  Created by Alexander Skorulis on 29/6/2022.

import Foundation

public struct HTTPJSONRequest<ResponseType>: HTTPRequest where ResponseType: Decodable {
    
    public var endpoint: String
    public var method: String = "GET"
    public var body: Data?
    public var headers: [String: String] = ["Accept": "application/json"]
    public var params: [String: String] = [:]
    
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    init<RequestType: Encodable>(endpoint: String, body: RequestType?) {
        self.endpoint = endpoint
        if let body = body {
            self.body = try! JSONEncoder().encode(body)
            self.headers["Content-Type"] = "application/json"
        }
    }
    
    init(endpoint: String, formParams: [URLQueryItem]) {
        self.endpoint = endpoint
        var urlComponents = URLComponents()
        urlComponents.queryItems = formParams
        self.headers["Content-Type"] = "application/x-www-form-urlencoded"
        self.body = urlComponents.query?.data(using: .utf8)
    }
    
    public func decode(data: Data, response: URLResponse) throws -> ResponseType {
        return try JSONDecoder().decode(ResponseType.self, from: data)
    }
}
