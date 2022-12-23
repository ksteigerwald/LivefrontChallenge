//
//  CryptoCompareModels.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import Foundation

struct CryptoCompareRequestParams: Encodable, URLQueryItemConvertible {
    /// A list of feeds to include in the response.
    let feeds: String?

    /// A list of categories to include in the response.
    let categories: String?

    /// A list of categories to exclude from the response.
    let excludeCategories: String?

    /// A timestamp for the latest articles to include in the response.
    let lTs: Date?

    /// The language to include in the response.
    let lang: String = "EN"

    /// The sort order for the response.
    let sortOrder: String?

    /// Extra parameters for the response.
    let extraParams: String?

    /// A boolean value indicating whether or not to sign the request.
    let sign: Bool?
}

struct CryptoCompareResponse: Decodable {
    /// The type of the response, with a value of 100 indicating success
    let type: Int
    /// A message describing the response
    let message: String
    /// An array of promoted news articles
    let promoted: [PromotedArticle]
    /// An array of news articles
    let data: [NewsArticle]
}

struct PromotedArticle: Decodable {
    // TODO: add properties
}

struct NewsArticle: Decodable {
    /// The ID of the news article
    let id: String
    /// The globally unique identifier of the news article
    let guid: String
    /// The Unix timestamp of when the article was published
    let publishedOn: Int
    /// The URL of the article's image
    let imageUrl: String
    /// The title of the article
    let title: String
    /// The URL of the article
    let url: String
    /// The body of the article
    let body: String
    /// A list of tags for the article
    let tags: String
    /// The language of the article
    let lang: String
    /// The number of upvotes for the article
    let upvotes: String
    /// The number of downvotes for the article
    let downvotes: String
    /// The categories the article belongs to
    let categories: String
    /// Information about the source of the article
    let sourceInfo: SourceInfo
    /// The source of the article
    let source: String
}

struct SourceInfo: Decodable {
    /// The name of the source
    let name: String
    /// The URL of the source's image
    let img: String
    /// The language of the source
    let lang: String
}
