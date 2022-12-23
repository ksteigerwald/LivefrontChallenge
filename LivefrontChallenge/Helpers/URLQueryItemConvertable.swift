//
//  URLQueryItemConvertable.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import Foundation

/// Protocol for converting an object to an array of `URLQueryItem`s
protocol URLQueryItemConvertible {
    /// Converts the object to an array of `URLQueryItem`s
    func asURLQueryItems() -> [URLQueryItem]
}

extension URLQueryItemConvertible where Self: Encodable {
    /// Converts the object to an array of `URLQueryItem`s by encoding the object as JSON and then converting it to a dictionary.
    /// - Returns: An array of `URLQueryItem`s representing the key-value pairs in the dictionary. If an error occurs during encoding or serialization, an empty array is returned.
    func asURLQueryItems() -> [URLQueryItem] {
        do {
            // Encode the object as JSON data
            let data = try JSONEncoder().encode(self)
            // Convert the JSON data to a dictionary
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            // Map the dictionary to an array of URLQueryItems
            return dictionary?.map { URLQueryItem(name: $0, value: "\($1)") } ?? []
        } catch {
            return []
        }
    }
}
