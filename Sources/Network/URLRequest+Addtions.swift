//  Created by Alexander Skorulis on 18/9/2022.

import Foundation

public extension URLRequest {
    
    mutating func add(param: String, value: String) {
        var urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        var items: [URLQueryItem] = urlComponents?.queryItems ?? []
        items.append(URLQueryItem(name: param, value: value))
        urlComponents?.queryItems = items
        url = urlComponents?.url
    }
    
}
