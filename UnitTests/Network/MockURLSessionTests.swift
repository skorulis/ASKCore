import Foundation
import Testing
import ASKCore

@Suite
struct MockURLSessionTests {
    private func makeMocksDirectory() throws -> URL {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("MockURLSessionTests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    private func writeMock(_ contents: String, at path: String, in directory: URL) throws {
        let fileURL = directory.appendingPathComponent(path)
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data(contents.utf8).write(to: fileURL)
    }

    private func request(_ path: String) -> URLRequest {
        URLRequest(url: URL(string: "http://localhost:3001\(path)")!)
    }

    @Test func returnsFileContentsForMatchingPath() async throws {
        let directory = try makeMocksDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        try writeMock("{\"token\":\"abc\"}", at: "api/auth/sign-in/email.json", in: directory)

        let session = MockURLSession(directory: directory)
        let (data, response) = try await session.data(for: request("/api/auth/sign-in/email"))

        let httpResponse = try #require(response as? HTTPURLResponse)
        #expect(httpResponse.statusCode == 200)
        #expect(httpResponse.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(String(data: data, encoding: .utf8) == "{\"token\":\"abc\"}")
    }

    @Test func ignoresQueryString() async throws {
        let directory = try makeMocksDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        try writeMock("{}", at: "api/things.json", in: directory)

        let session = MockURLSession(directory: directory)
        let (_, response) = try await session.data(for: request("/api/things?foo=bar&baz=1"))

        #expect((response as? HTTPURLResponse)?.statusCode == 200)
    }

    @Test func returns404ForMissingFile() async throws {
        let directory = try makeMocksDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }

        let session = MockURLSession(directory: directory)
        let (data, response) = try await session.data(for: request("/api/missing"))

        #expect((response as? HTTPURLResponse)?.statusCode == 404)
        #expect(data.isEmpty)
    }

    @Test func returns404WhenDirectoryIsNil() async throws {
        let session = MockURLSession(directory: nil)
        let (data, response) = try await session.data(for: request("/api/auth/sign-in/email"))

        #expect((response as? HTTPURLResponse)?.statusCode == 404)
        #expect(data.isEmpty)
    }

    @Test func visitBatchMockAcknowledgesSubmittedIDsForBodyAndStream() async throws {
        let directory = try makeMocksDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        try writeMock("{\"acceptedIds\":[],\"visits\":[]}", at: "api/hex-visits/batch.json", in: directory)
        let session = MockURLSession(directory: directory)
        let body = Data("{\"visits\":[{\"id\":\"a\"},{\"id\":\"b\"}]}".utf8)
        for usesStream in [false, true] {
            var batchRequest = request("/api/hex-visits/batch")
            batchRequest.httpMethod = "POST"
            if usesStream {
                batchRequest.httpBodyStream = InputStream(data: body)
            } else {
                batchRequest.httpBody = body
            }
            let (data, response) = try await session.data(for: batchRequest)
            let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
            #expect((response as? HTTPURLResponse)?.statusCode == 200)
            #expect(json["acceptedIds"] as? [String] == ["a", "b"])
        }
    }

    @Test func returns404ForPathTraversal() async throws {
        let directory = try makeMocksDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        try writeMock("{}", at: "secret.json", in: directory)

        let session = MockURLSession(directory: directory)
        let (_, response) = try await session.data(for: request("/../secret"))

        #expect((response as? HTTPURLResponse)?.statusCode == 404)
    }
}
