//
//  Sanitize+JSON.swift
//  Sanitize
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import JSON

extension JSON {
    /// Sanitize the JSON deleting no allowed keys
    ///
    /// - Parameter keys: allowed keys
    /// - Returns: a JSON with allowed keys
    public func sanitize(_ keys: [String]) -> JSON {
        guard var object = self.object else { return self }

        object.forEach { key, _ in
            if !keys.contains(key) {
                object[key] = nil
            }
        }

        return JSON(Node.object(object))
    }
}
