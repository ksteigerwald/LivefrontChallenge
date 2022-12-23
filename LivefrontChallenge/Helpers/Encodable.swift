//
//  Encodable.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return [:]
        }
        return dictionary
    }
}
