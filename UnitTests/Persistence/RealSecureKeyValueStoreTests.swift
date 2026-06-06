//  Created by Alexander Skorulis on 6/6/2026.

import Foundation
import Testing
@testable import ASKCore

@Suite
struct RealSecureKeyValueStoreTests {

    private final class Harness {
        let store: RealSecureKeyValueStore
        private var keys: Set<String> = []

        init() {
            store = RealSecureKeyValueStore(service: UUID().uuidString)
        }

        func track(_ key: String) {
            keys.insert(key)
        }

        func cleanup() {
            for key in keys {
                store.removeObject(forKey: key)
            }
        }
    }

    @Test func setAndGetString() {
        let harness = Harness()
        defer { harness.cleanup() }

        let store = harness.store
        let key = "greeting"
        harness.track(key)

        #expect(store.string(forKey: key) == nil)

        store.set("hello", forKey: key)
        #expect(store.string(forKey: key) == "hello")

        store.set("hello world", forKey: key)
        #expect(store.string(forKey: key) == "hello world")

        store.removeObject(forKey: key)
        #expect(store.string(forKey: key) == nil)
    }

    @Test func setAndGetData() {
        let harness = Harness()
        defer { harness.cleanup() }

        let store = harness.store
        let key = "payload"
        harness.track(key)
        let payload = Data([0x01, 0x02, 0x03, 0xFF])

        #expect(store.data(forKey: key) == nil)

        store.set(payload, forKey: key)
        #expect(store.data(forKey: key) == payload)

        store.removeObject(forKey: key)
        #expect(store.data(forKey: key) == nil)
    }

    @Test func setAndGetDouble() {
        let harness = Harness()
        defer { harness.cleanup() }

        let store = harness.store
        let key = "score"
        harness.track(key)

        #expect(store.double(forKey: key) == 0)

        store.set(3.14, forKey: key)
        #expect(store.double(forKey: key) == 3.14)

        store.removeObject(forKey: key)
        #expect(store.double(forKey: key) == 0)
    }

    @Test func setNilRemovesValue() {
        let harness = Harness()
        defer { harness.cleanup() }

        let store = harness.store
        let key = "token"
        harness.track(key)

        store.set("secret", forKey: key)
        #expect(store.string(forKey: key) == "secret")

        store.set(nil, forKey: key)
        #expect(store.string(forKey: key) == nil)
    }

    @Test func codableRoundTrip() throws {
        let harness = Harness()
        defer { harness.cleanup() }

        let store = harness.store
        let key = "user"
        harness.track(key)

        struct User: Codable, Equatable {
            let name: String
            let age: Int
        }

        let user = User(name: "Alex", age: 30)
        try store.set(codable: user, forKey: key)
        #expect(try store.codable(forKey: key, type: User.self) == user)

        try store.setOrClear(codable: User?.none, forKey: key)
        #expect(try store.codable(forKey: key, type: User.self) == nil)
    }

    @Test func dateRoundTrip() {
        let harness = Harness()
        defer { harness.cleanup() }

        let store = harness.store
        let key = "savedDate"
        harness.track(key)
        let date = Date(timeIntervalSince1970: 1_700_000_000)

        #expect(store.double(forKey: key) == 0)

        store.set(date: date, forKey: key)
        #expect(store.date(forKey: key) == date)

        store.set(date: nil, forKey: key)
        #expect(store.date(forKey: key) == Date(timeIntervalSince1970: 0))
    }
}
