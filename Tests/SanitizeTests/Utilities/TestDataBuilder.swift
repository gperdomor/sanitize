//
//  TestDataBuilder.swift
//  SanitizeTests
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

// swiftlint:disable force_try

import HTTP
@testable import Sanitize

class TestDataBuilder {
    static func getRequest(body: JSON) throws -> Request {
        return Request(
            method: .post,
            uri: "/sanitize",
            headers: [
                "Content-Type": "application/json"
            ],
            body: Body(try body.data())
        )
    }

    static func buildInvalidRequest() -> Request {
        return Request(
            method: .post,
            uri: "/sanitize"
        )
    }
}
