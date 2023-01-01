//
//  StringExtension.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import Foundation

public struct ParsedDoc {
    public let headline: String
    public let body: String
}
extension String {
    /// Parses a string into a headline and body.
    /// - Returns: An array containing the headline and body, or `nil` if there are fewer than 2 lines in the string.
    func parseHeadlineAndBody() -> ParsedDoc? {
        var filtered = (self as NSString).components(separatedBy: "\n").filter { element in
            element.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        }

        guard filtered.count >= 2 else {
            return nil
        }
        let headline = filtered.remove(at: 0)
        let body = filtered.joined(separator: "\n\n")

        return ParsedDoc(headline: headline, body: body)
    }

    func truncate(maxLength: Int) -> String {
        if self.count <= maxLength {
            return self
        } else {
            return String(self[..<self.index(self.startIndex, offsetBy: maxLength)])
        }
    }
}
