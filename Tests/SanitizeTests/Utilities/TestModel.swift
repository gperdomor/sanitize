//
//  TestModel.swift
//  SanitizeTests
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Node
import JSON
import Vapor

@testable import Sanitize

class TestModel: Sanitizable {
    var id: Node?
    var name: String
    var email: String

    static var allowedKeys: [String] = ["name", "email"]

    required init(json: JSON) throws {
        id = try json.get("id")
        name = try json.get("name")
        email = try json.get("email")
    }
}

extension TestModel {
    static func preSanitize(data: JSON) throws {
        guard data["name"]?.string != nil else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "No name provided."
            )
        }

        guard data["email"]?.string != nil else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "No email provided."
            )
        }
    }

    func postSanitize() throws {
        guard email.characters.count > 8 else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Email must be longer than 8 characters."
            )
        }
    }
}
