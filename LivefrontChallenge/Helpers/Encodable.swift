//
//  Encodable.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation
/// Extension for Encodable types to convert to a dictionary representation.
extension Encodable {
    /// - Returns: A dictionary representation of the Encodable
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return [:]
        }
        return dictionary
    }
}
