//  Created by Alexander Skorulis on 29/6/2022.

import Foundation
import os.log

public struct HTTPLogger {
    
    var level: Level
    
    public init(level: Level = .errors) {
        self.level = level
    }
    
    func enable() -> HTTPLogger {
        var logger = self
        logger.level = .full
        return logger
    }
    
    func log(request: URLRequest, level: Level?) {
        if !(level ?? self.level).shouldLog(isError: false) { return }
        let isJSON = isJSONContent(headers: request.allHTTPHeaderFields)
        
        print(
"""
----REQUEST BEGIN----
\(request.httpMethod ?? "-"): \(request.url?.absoluteString ?? "-")
Body:\n\(dataText(data: request.httpBody, isJSON: isJSON))
Headers:\n\(headerText(headers: request.allHTTPHeaderFields))
----REQUEST END------
"""
        )
    }
    
    func log(response: URLResponse, data: Data?, level: Level?) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let isError = statusCode >= 400
        if !(level ?? self.level).shouldLog(isError: isError) { return }
        let headers = (response as? HTTPURLResponse)?.allHeaderFields
        
        let isJSON = isJSONContent(headers: headers)
        
        print(
"""
---RESPONSE BEGIN---
URL: \(response.url?.absoluteString ?? "-")
Status: \(statusCode)
Body:\n\(dataText(data: data, isJSON: isJSON))
HEADERS:\n\(headerText(headers: headers))
---RESPONSE END----
"""
        )
    }
    
}

// MARK: - Inner Types
public extension HTTPLogger {
    enum Level: String, Equatable {
        case off
        case errors
        case full
        
        fileprivate func shouldLog(isError: Bool) -> Bool {
            switch self {
            case .off: return false
            case .errors: return isError
            case .full: return true
            }
        }
    }
    
}

// MARK: - Inner Logic
extension HTTPLogger {
    
    private func dataText(data: Data?, isJSON: Bool) -> String {
        guard let data = data else { return "-"}
        if isJSON {
            let object = try! JSONSerialization.jsonObject(with: data, options: [])
            let data = try! JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            return String(data: data, encoding: .utf8)!
        }
        return String(data: data, encoding: .utf8) ?? "ERROR"
    }
    
    private func headerText(headers: [AnyHashable: Any]?) -> String {
        guard let headers else { return "" }
        return headers.map { (key, value) in
            return "\(key): \(value)"
        }
        .joined(separator: "\n")
    }
    
    private func isJSONContent(headers: [AnyHashable: Any]?) -> Bool {
        let contentType  = headers?["Content-Type"] as? String
        return contentType?.starts(with: "application/json") ?? false
    }
}
