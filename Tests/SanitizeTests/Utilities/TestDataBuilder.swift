//
//  TestDataBuilder.swift
//  SanitizeTests
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

// swiftlint:disable force_try

import HTTP
import JSON
import Node

class TestDataBuilder {
    static func getRequest(body: Node) -> Request {
        let body = try! JSON(node: body).makeBytes()

        return Request(
            method: .post,
            uri: "/sanitize",
            headers: [
                "Content-Type": "application/json"
            ],
            body: .data(body)
        )
    }

    static func buildInvalidRequest() -> Request {
        return Request(
            method: .post,
            uri: "/sanitize"
        )
    }
}
