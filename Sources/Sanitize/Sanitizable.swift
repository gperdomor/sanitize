//
//  Sanitizable.swift
//  Sanitize
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]

/// A request-extractable object.
public protocol Sanitizable: Decodable {
    /// Keys that are permitted to be deserialized from a Request's body.
    static var allowedKeys: [String] { get }

    /// Validate the Request's body before constructing a Model.
    /// Useful for checking if fields exist.
    static func preSanitize(data: JSON) throws

    /// Validate all deserialized fields.
    func postSanitize() throws
}

public extension Sanitizable {
    public static func preSanitize(data: JSON) throws { }

    public func postSanitize() throws { }
}
