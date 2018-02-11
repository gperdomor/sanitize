//
//  JSONTests.swift
//  SanitizeTests
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import XCTest
import HTTP
import Vapor

@testable import Sanitize

class JSONTests: XCTestCase {
    // MARK: - Extraction.
    func testPermitted() {
        let json: JSON = [
            "id": 1,
            "name": "Brett",
            "email": "test@tested.com"
            ]

        let result = json.sanitize(["name"])
        XCTAssertNil(result["id"])
        XCTAssertEqual(result["name"] as? String, "Brett")
        XCTAssertNil(result["email"])
    }

    func testEmptyPermitted() {
        let json: JSON = [
            "id": 1,
            "name": "Brett",
            "email": "test@tested.com"
            ]

        let result = json.sanitize([])
        XCTAssertNil(result["id"])
        XCTAssertNil(result["name"])
        XCTAssertNil(result["email"])
    }
}

// MARK: Manifest
extension JSONTests {
    func testLinuxTestSuiteIncludesAllTests() throws {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = Int(thisClass.defaultTestSuite.testCaseCount)

            XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    static let allTests = [
        // LinuxValidation
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        // SanitizeTests
        ("testPermitted", testPermitted),
        ("testEmptyPermitted", testEmptyPermitted)
    ]
}
