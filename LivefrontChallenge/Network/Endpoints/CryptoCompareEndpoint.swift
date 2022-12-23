//
//  CryptoCompareEndpoint.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import Foundation

/// Enum representing the different endpoints available in the OpenAI API
enum CryptoCompareEndpoint {
    case news(params: CryptoCompareRequestParams)
    case newsCategories
}

extension CryptoCompareEndpoint: Endpoint {
    var network: Networks {
        .cryptoCompare
    }

    var path: String {
        switch self {
        case .news: return "v2/news/"
        case .newsCategories: return "news/categories"
        }
    }

    var method: RequestMethod {
        .post
    }

    var body: [String: Any]? {
        nil
    }

    var parameters: [URLQueryItem]? {
        switch self {
        case .news(let params): return params.asURLQueryItems()
        default: return nil
        }
    }
}
