//  Created by Alexander Skorulis on 29/6/2022.

import Foundation

// MARK: - Memory footprint

open class HTTPService {
    
    private let baseURL: String?
    private let urlSession: URLSession
    
    public init(baseURL: String? = nil) {
        self.baseURL = baseURL
        urlSession = URLSession(configuration: .default)
    }
    
}

// MARK: - Logic

public extension HTTPService {
    
    func execute<R: HTTPRequest>(request: R) async throws -> R.ResponseType {
        var urlRequest = try getURLRequest(req: request)
        modify(request: &urlRequest)
        let result = try await urlSession.data(for: urlRequest)
        if let status = (result.1 as? HTTPURLResponse)?.statusCode, status >= 400 {
            throw URLError(.badServerResponse)
        }
        return try request.decode(data: result.0, response: result.1)
    }
    
    func modify(request: inout URLRequest) {
        // Default does nothing
    }
    
    private func getURLRequest<R: HTTPRequest>(req: R) throws -> URLRequest {
        let url = try getURLPath(endpoint: req.endpoint)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if req.params.count > 0 {
            components.queryItems = req.params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = req.method
        request.httpBody = req.body
        request.allHTTPHeaderFields = req.headers
        return request
    }
    
    private func getURLPath(endpoint: String) throws -> URL {
        if endpoint.starts(with: "https://") || endpoint.starts(with: "http://") {
            guard let url = URL(string: endpoint) else {
                throw URLError(.badURL)
            }
            return url
        }
        if let baseURL = baseURL, let url = URL(string: baseURL) {
            return url.appendingPathComponent(endpoint)
        }
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        return url
    }
    
}
