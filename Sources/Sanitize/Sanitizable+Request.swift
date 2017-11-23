//
//  Sanitizable+Request.swift
//  Sanitize
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Foundation
import HTTP
import Vapor

extension Request {
    /// Extracts an model from the Request's JSON, first stripping sensitive fields.
    ///
    /// - Throws:
    ///     - badRequest: Thrown when the request doesn't have a JSON body.
    ///     - CustomError: `Sanitizable` models have the ability to throw errors
    ///         when a model fails to instantiate using the `preSanitize` and
    ///         `postSanitize` methods.
    /// - Returns: The extracted, sanitized object.
    public func extractModel<M>() throws -> M where M: Sanitizable {
        return try extractModel(injecting: nil)
    }

    /// Extracts a object from the Request's JSON, first by adding/overriding
    /// the given values and next stripping sensitive fields.
    ///
    /// - Parameter values: Values to set before sanitizing.
    /// - Returns: The extracted, sanitized object.
    /// - Throws:
    ///     - badRequest: Thrown when the request doesn't have a JSON body.
    ///     - CustomError: `Sanitizable` models have the ability to throw errors
    ///         when a model fails to instantiate using the `preSanitize` and
    ///         `postSanitize` methods.
    /// - Returns: The extracted, sanitized object.
    public func extractModel<M>(injecting values: JSON?) throws -> M where M: Sanitizable {
        guard let contentType = self.headers[.contentType], MediaType.json.description.hasPrefix(contentType),
            let json = try JSONSerialization.jsonObject(with: self.body.data, options: []) as? JSON else {
                throw Abort(.badRequest)
        }

        var sanitized = json.sanitize(M.allowedKeys)

        values?.forEach { key, value in
            sanitized[key] = value
        }

        try M.preSanitize(data: sanitized)

        let data = try JSONSerialization.data(withJSONObject: sanitized)

        let decoder = JSONDecoder()
        let model: M = try decoder.decode(M.self, from: data)

        try model.postSanitize()

        return model
    }
}
