import Foundation

public final class MockURLSession: URLSessionProtocol, @unchecked Sendable {
    private let mocksDirectory: URL?

    public init(directory: URL?) {
        mocksDirectory = directory
    }

    public convenience init(bundle: Bundle = .main, subdirectory: String = "Mocks") {
        self.init(directory: bundle.bundleURL.appendingPathComponent(subdirectory, isDirectory: true))
    }

    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let fileURL = mockFileURL(for: request),
              let data = try? Data(contentsOf: fileURL) else {
            return (Data(), Self.response(for: request, status: 404))
        }
        let responseData = try Self.visitBatchResponse(for: request, template: data)
        return (responseData, Self.response(for: request, status: 200))
    }

    private static func visitBatchResponse(for request: URLRequest, template: Data) throws -> Data {
        guard request.url?.path == "/api/hex-visits/batch", request.httpMethod == "POST" else { return template }
        var body = request.httpBody
        if body == nil, let stream = request.httpBodyStream {
            stream.open()
            defer { stream.close() }
            var data = Data()
            var buffer = [UInt8](repeating: 0, count: 4096)
            while stream.hasBytesAvailable {
                let count = stream.read(&buffer, maxLength: 4096)
                if count < 0 { throw stream.streamError ?? URLError(.cannotDecodeContentData) }
                if count == 0 { break }
                data.append(contentsOf: buffer.prefix(count))
            }
            body = data
        }
        guard let body,
              let payload = try JSONSerialization.jsonObject(with: body) as? [String: Any],
              let visits = payload["visits"] as? [[String: Any]],
              var response = try JSONSerialization.jsonObject(with: template) as? [String: Any] else {
            return template
        }
        response["acceptedIds"] = visits.compactMap { $0["id"] as? String }
        return try JSONSerialization.data(withJSONObject: response)
    }

    private func mockFileURL(for request: URLRequest) -> URL? {
        guard let mocksDirectory,
              let path = request.url?.path else { return nil }
        let components = path.split(separator: "/").map(String.init)
        guard !components.isEmpty, !components.contains("..") else { return nil }
        var url = mocksDirectory
        for component in components {
            url.appendPathComponent(component)
        }
        url.appendPathExtension("json")
        return url
    }

    private static func response(for request: URLRequest, status: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: request.url ?? URL(fileURLWithPath: "/"),
            statusCode: status,
            httpVersion: nil,
            headerFields: status == 200 ? ["Content-Type": "application/json"] : nil
        )!
    }
}
