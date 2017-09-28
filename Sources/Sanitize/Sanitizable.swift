//
//  Sanitizable.swift
//  Sanitize
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import JSON
import Node

/// A request-extractable object.
public protocol Sanitizable: JSONInitializable, NodeRepresentable {
    /// Keys that are permitted to be deserialized from a Request's JSON.
    static var allowedKeys: [String] { get }
}
