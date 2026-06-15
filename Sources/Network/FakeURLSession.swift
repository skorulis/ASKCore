//  Created by Alexander Skorulis on 15/6/2026.

import Foundation

public final class FakeURLSession: URLSessionProtocol, @unchecked Sendable {
    private let handler: @Sendable (URLRequest) async throws -> (Data, URLResponse)

    public init(handler: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse)) {
        self.handler = handler
    }

    public convenience init(data: Data, response: HTTPURLResponse) {
        self.init { _ in (data, response) }
    }

    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await handler(request)
    }
}
