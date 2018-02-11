//
//  Sanitize+JSON.swift
//  Sanitize
//
//  Created by Gustavo Perdomo on 9/28/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    /// Sanitize the JSON Dictionary deleting no allowed keys
    ///
    /// - Parameter keys: allowed keys
    /// - Returns: a JSON with allowed keys
    public func sanitize(_ keys: [String]) -> Dictionary {
        var dict = self

        dict.forEach { key, _ in
            if !keys.contains(key) {
                dict.removeValue(forKey: key)
            }
        }

        return dict
    }

    /// Converts the Dictionary to Data
    ///
    /// - Returns: The JSON Data representation
    /// - Throws: <#throws value description#>
    public func data() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self)
    }
}
