//
//  HackerNews.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/27/22.
//

import Foundation

enum HackerNewsEndpoint {
    case topStories
    case newsItem(article: Int)
}

extension HackerNewsEndpoint: Endpoint {

    var path: String {
        switch self {
        case .topStories: return "v0/topstories.json"
        case .newsItem(let article):
            return "v0/item/\(article)"
        }
    }

    var method: RequestMethod {
        .get
    }

    var body: [String : Any]? {
        nil
    }

    var parameters: [URLQueryItem]? {
        nil
    }

    var network: Networks {
        .hackerNews
    }


}
