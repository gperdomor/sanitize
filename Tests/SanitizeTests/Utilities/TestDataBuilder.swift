//
//  TestDataBuilder.swift
//  SanitizeTests
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import HTTP
import Vapor
@testable import Sanitize

class TestDataBuilder {
    static func getRequest(body: JSON, for container: Container) throws -> Request {
        let httpRequest =  HTTPRequest(
            method: .post,
            uri: "/sanitize",
            headers: [
                "Content-Type": "application/json"
            ],
            body: HTTPBody(try body.data())
        )

        return Request(http: httpRequest, using: container)
    }

    static func buildInvalidRequest(for container: Container) -> Request {
        let httpRequest =  HTTPRequest(
            method: .post,
            uri: "/sanitize"
        )

        return Request(http: httpRequest, using: container)
    }
}
