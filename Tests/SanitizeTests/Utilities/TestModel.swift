//
//  TestModel.swift
//  SanitizeTests
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Vapor

@testable import Sanitize

class TestModel: Sanitizable {
    var id: Int?
    var name: String
    var email: String

    static var allowedKeys: [String] = ["name", "email"]

     init() throws {
        name = "DEFAULT"
        email = "DEFAULT"
    }
}

extension TestModel {
    static func preSanitize(data: JSON) throws {
        guard data["name"] as? String != nil else {
            throw Abort(
                .badRequest,
                reason: "No name provided."
            )
        }

        guard data["email"] as? String != nil else {
            throw Abort(
                .badRequest,
                reason: "No email provided."
            )
        }
    }

    func postSanitize() throws {
        guard email.count > 8 else {
            throw Abort(
                .badRequest,
                reason: "Email must be longer than 8 characters."
            )
        }
    }
}
