//  Created by Alexander Skorulis on 29/6/2022.

import Foundation

public struct HTTPJSONRequest<ResponseType>: HTTPRequest where ResponseType: Decodable {
    
    public var endpoint: String
    public var method: String = "GET"
    public var body: Data?
    public var headers: [String: String] = ["Accept": "application/json"]
    public var params: [String: String] = [:]
    public var decoder: JSONDecoder = JSONDecoder()
    
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    public init<RequestType: Encodable>(
        endpoint: String,
        body: RequestType,
        method: String = "POST"
    ) {
        self.endpoint = endpoint
        self.method = method
        self.body = try! JSONEncoder().encode(body)
        self.headers["Content-Type"] = "application/json"
    }
    
    public init(endpoint: String, formParams: [URLQueryItem]) {
        self.endpoint = endpoint
        var urlComponents = URLComponents()
        urlComponents.queryItems = formParams
        self.headers["Content-Type"] = "application/x-www-form-urlencoded"
        self.body = urlComponents.query?.data(using: .utf8)
    }
    
    public func decode(data: Data, response: URLResponse) throws -> ResponseType {
        return try decoder.decode(ResponseType.self, from: data)
    }
}
