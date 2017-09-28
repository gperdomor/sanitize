//
//  TestModel.swift
//  SanitizeTests
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Node
import JSON

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

    func makeNode(in context: Context?) throws -> Node {
        return try Node(node: [
            "id": id as Any,
            "name": name,
            "email": email
            ])
    }
}
