//
//  OpenAIEndpoint.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

/// Enum representing the different endpoints available in the OpenAI API
enum OpenAIEndpoint {
    /// Endpoint for retrieving summaries of a list of URLs
    case documents(params: OpenAIRequestParams)
}

extension OpenAIEndpoint: Endpoint {
    var network: Networks {
        return .openai
    }

    var path: String {
        switch self {
        case .documents:
            return "documents"
        }
    }

    var method: RequestMethod {
        return .post
    }

    var body: [String: AnyObject]? {
        switch self {
        case .documents(let requestParams):
            return nil
        }
    }

    var parameters: [URLQueryItem]? {
        nil
    }
}
