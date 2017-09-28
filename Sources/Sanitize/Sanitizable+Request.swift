//
//  Sanitizable+Request.swift
//  Sanitize
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import HTTP
import Node
import Vapor

extension Request {
    /// Extracts an model from the Request's JSON, first stripping sensitive fields.
    ///
    /// - Throws:
    ///     - badRequest: Thrown when the request doesn't have a JSON body.
    ///
    /// - Returns: The extracted, sanitized object.
    public func extractModel<M>() throws -> M where M: Sanitizable {
        return try extractModel(injecting: .null)
    }

    /// Extracts a object from the Request's JSON, first by adding/overriding
    /// the given values and next stripping sensitive fields.
    ///
    /// - Parameter values: Values to set before sanitizing.
    /// - Returns: The extracted, sanitized object.
    /// - Throws:
    ///     - badRequest: Thrown when the request doesn't have a JSON body.
    public func extractModel<M>(injecting values: Node) throws -> M where M: Sanitizable {
        guard let json = self.json else {
            throw Abort.badRequest
        }

        var sanitized = json.sanitize(M.allowedKeys)

        values.object?.forEach { key, value in
            sanitized[key] = JSON(value)
        }

        try M.preSanitize(data: sanitized)

        let model: M = try M(json: sanitized)

        try model.postSanitize()

        return model
    }
}
