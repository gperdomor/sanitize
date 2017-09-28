//
//  SanitizeTests.swift
//  SanitizeTests
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import XCTest
import HTTP
import Vapor

@testable import Sanitize

class SanitizeTests: XCTestCase {

    // MARK: - Extraction.

    func testBasic() throws {
        let req = TestDataBuilder.getRequest(body: [
            "id": 1,
            "name": "John Appleseed",
            "email": "domain@example.com"
            ])

        let model: TestModel = try req.extractModel()
        XCTAssertNil(model.id)
        XCTAssertEqual(model.name, "John Appleseed")
        XCTAssertEqual(model.email, "domain@example.com")
    }

    func testBasicFailed() throws {
        let request = TestDataBuilder.buildInvalidRequest()

        assertError(Abort.badRequest) {
            let _: TestModel = try request.extractModel()
        }
    }

    // MARK: - Injection.

    func testInjectingNewKeys() throws {
        let request = TestDataBuilder.getRequest(body: [
            "id": 1,
            "name": "John Appleseed"
            ])

        let model: TestModel = try request.extractModel(
            injecting: ["email": "domain@example.com"]
        )
        XCTAssertNil(model.id)
        XCTAssertEqual(model.name, "John Appleseed")
        XCTAssertEqual(model.email, "domain@example.com")

    }

    func testOverridingKeys() throws {
        let request = TestDataBuilder.getRequest(body: [
            "id": 1,
            "name": "John Appleseed",
            "email": "domain@example.com"
            ])

        let model: TestModel = try request.extractModel(
            injecting: ["email": "domain@overrided.com"]
        )

        XCTAssertNil(model.id)
        XCTAssertEqual(model.name, "John Appleseed")
        XCTAssertEqual(model.email, "domain@overrided.com")

    }

    func testInjectingSanitizedKeys() throws {
        let request = TestDataBuilder.getRequest(body: [
            "id": 1,
            "name": "John Appleseed",
            "email": "domain@example.com"
            ])

        let model: TestModel = try request.extractModel(
            injecting: ["id": 1337]
        )

        XCTAssertEqual(model.id, 1337)
        XCTAssertEqual(model.name, "John Appleseed")
        XCTAssertEqual(model.email, "domain@example.com")
    }

    // MARK: - Validation.

    func testPreSanitizeError() {
        let request = TestDataBuilder.getRequest(body: [
            "email": "domain@example.com"
            ])

        assertError(Abort(.badRequest, metadata: nil, reason: "No name provided.")) {
            let _: TestModel = try request.extractModel()
        }
    }

    func testPostSanitizeError() {
        let request = TestDataBuilder.getRequest(body: [
            "id": 1,
            "name": "John Appleseed",
            "email": "d@e.com"
            ])

        assertError(Abort(.badRequest, metadata: nil, reason: "Email must be longer than 8 characters.")) {
            let _: TestModel = try request.extractModel()
        }
    }
}

// MARK: Manifest
extension SanitizeTests {
    func testLinuxTestSuiteIncludesAllTests() throws {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            #if swift(>=4.0)
                let darwinCount = Int(thisClass.defaultTestSuite.testCaseCount)
            #else
                let darwinCount = Int(thisClass.defaultTestSuite().testCaseCount)
            #endif

            XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    static let allTests = [
        // LinuxValidation
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        // SanitizeTests
        ("testBasic", testBasic),
        ("testBasicFailed", testBasicFailed),
        ("testInjectingNewKeys", testInjectingNewKeys),
        ("testOverridingKeys", testOverridingKeys),
        ("testInjectingSanitizedKeys", testInjectingSanitizedKeys),
        ("testPreSanitizeError", testPreSanitizeError),
        ("testPostSanitizeError", testPostSanitizeError)
    ]
}

func assertError<E: Error, ReturnType>(
    _ expected: E,
    file: StaticString = #file,
    line: UInt = #line,
    from closure: () throws -> ReturnType
    ) where E: Equatable {
    do {
        _ = try closure()
        XCTFail("should have thrown", file: file, line: line)
    } catch let error as E {
        XCTAssertEqual(error, expected, file: file, line: line)
    } catch {
        XCTFail(
            "expected type \(type(of: expected)) got \(type(of: error))",
            file: file,
            line: line
        )
    }
}

extension Abort: Equatable {
    static public func == (lhs: Abort, rhs: Abort) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.reason == rhs.reason
    }
}
