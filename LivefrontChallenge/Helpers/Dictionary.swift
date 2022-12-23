//
//  Dictionary.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

extension Dictionary {
    /// Combines two dictionaries creating a mutuable copy
    func comb(dict: [Key: Value]) -> [Key: Value] {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}
