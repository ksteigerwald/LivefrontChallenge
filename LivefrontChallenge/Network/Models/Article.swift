//
//  Article.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/30/22.
//

import Foundation

/// Article Model Used to transform response into
struct Article: Hashable {
    let category: String
    let document: String
    let headline: String
    let body: String
    let articleURL: String
    let imageURL: String
    /// Initializes an `Article` instance.
    /// - Parameters:
    ///   - category: The category of the article.
    ///   - document: The document containing the headline and body of the article.
    ///   - headline: (Optional) The headline of the article. If not provided, the first line of the `document` will be used.
    ///   - body: (Optional) The body of the article. If not provided, the second line of the `document` will be used.
    init(
        category: String = "",
        document: String = "",
        headline: String? = nil,
        body: String? = nil,
        articleURL: String = "",
        imageURL: String = "https://placeimg.com/320/240/any",
        parse: Bool = true
    ) {
        var content: [String]

        // TODO: remove, used for debugging
        if parse {
            content = document.parseHeadlineAndBody()
        } else {
            content = [headline ?? "-", body ?? "+"]
        }
        self.category = category
        self.document = document
        self.imageURL = imageURL
        self.articleURL = articleURL
        self.headline = content.remove(at: 0)
        self.body = content.joined(separator: "\n\n")
    }
}
