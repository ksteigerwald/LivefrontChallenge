//
//  GeckoEndpoint.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

enum GeckoEndpoint {}

extension GeckoEndpoint: Endpoint {
    var path: String {
        switch self {
        default: return ""
        }
    }

    var method: RequestMethod {
        return .get
    }

    var body: [String : AnyObject]? {
        nil
    }

    var parameters: [URLQueryItem]? {
        nil
    }

    var network: Networks {
        return .gecko
    }
}
