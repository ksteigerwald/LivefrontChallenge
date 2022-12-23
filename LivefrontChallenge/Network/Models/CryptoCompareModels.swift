//
//  CryptoCompareModels.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import Foundation
import BackedCodable

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
    /// The type of response
      let type: Int
      /// The message of the response
      let message: String
      /// A list of promoted articles
      let promoted: [PromotedArticle]
      /// A list of news articles
      let articles: [NewsArticle]
      /// The rate limit for the response
      let rateLimit: RateLimit
      /// A boolean value indicating if the response has a warning
      let hasWarning: Bool

      private enum CodingKeys: String, CodingKey {
          case type = "Type"
          case message = "Message"
          case promoted = "Promoted"
          case articles = "Data"
          case rateLimit = "RateLimit"
          case hasWarning = "HasWarning"
      }

}

struct RateLimit: Decodable {
    // TODO: add properties
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
    let publishedOn: Int?
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
    let sourceInfo: SourceInfo?
    /// The source of the article
    let source: String

    private enum CodingKeys: String, CodingKey {
            case id
            case guid
            case publishedOn = "published_on"
            case imageUrl = "imageurl"
            case title
            case url
            case body
            case tags
            case lang
            case upvotes
            case downvotes
            case categories
            case sourceInfo = "source_info"
            case source
        }
}

struct SourceInfo: Decodable {
    let name: String
    let img: String
    let lang: String
}

struct CryptoCompareNewsCategoriesResponse: Decodable {
    /// The name of the news category
    let categoryName: String

    /// A list of words that are associated with the category
    let wordsAssociatedWithCategory: [String]?

    /// A list of phrases that are included in the category
    let includedPhrases: [String]?

    /// A list of phrases that are excluded from the category
    let excludedPhrases: [String]?

    private enum CodingKeys: String, CodingKey {
        case categoryName = "categoryName"
        case wordsAssociatedWithCategory = "wordsAssociatedWithCategory"
        case includedPhrases = "includedPhrases"
        case excludedPhrases = "excludedPhrases"
    }
}
