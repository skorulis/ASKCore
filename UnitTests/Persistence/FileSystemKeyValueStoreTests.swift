//  Created by Alexander Skorulis on 29/12/2025.

import Foundation
import XCTest
@testable import ASKCore

final class FileSystemKeyValueStoreTests: XCTestCase {
    private var baseFolder: String!

    override func setUp() {
        super.setUp()
        baseFolder = UUID().uuidString
    }
    
    override func tearDown() {
        super.tearDown()
        try! makeStore().removeAll()
    }

    // MARK: - Helpers

    private func makeStore() -> FileSystemKeyValueStore {
        return FileSystemKeyValueStore(folderName: baseFolder)
    }

    // MARK: - Tests

    func testSetAndGetString() {
        let store = makeStore()
        XCTAssertNil(store.string(forKey: "greeting"))
        
        // Set a value
        store.set("hello", forKey: "greeting")
        XCTAssertEqual(store.string(forKey: "greeting"), "hello")
        
        // Overwrite a value
        store.set("hello world", forKey: "greeting")
        XCTAssertEqual(store.string(forKey: "greeting"), "hello world")
        
        // Remove the value
        store.removeObject(forKey: "greeting")
        XCTAssertNil(store.string(forKey: "greeting"))
    }

}

