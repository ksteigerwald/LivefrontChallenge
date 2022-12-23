//
//  JSONPlaceHolderEndpoint.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

enum JSONPlaceHolderEndpoint {
    case getTest
}

extension JSONPlaceHolderEndpoint: Endpoint {
    var network: Networks {
        switch self {
            default: return .jsonPlaceHolder
        }
    }

    var path: String {
        switch self {
        default: return ""
        }
    }

    var method: RequestMethod {
        switch self {
        default: return .get
        }
    }

    var body: [String: Any]? {
        nil
    }

    var parameters: [URLQueryItem]? {
        nil
    }
}
