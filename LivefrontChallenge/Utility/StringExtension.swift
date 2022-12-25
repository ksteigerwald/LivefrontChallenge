//
//  StringExtension.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import Foundation

extension String {
    /// Parses a string into a headline and body.
    /// - Returns: An array containing the headline and body, or `nil` if there are fewer than 2 lines in the string.
    func parseHeadlineAndBody() -> [String]? {
        let filtered = (self as NSString).components(separatedBy: "\n").filter { element in
            element.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        }
        guard filtered.count >= 2 else { return nil }
        return filtered
    }
}
