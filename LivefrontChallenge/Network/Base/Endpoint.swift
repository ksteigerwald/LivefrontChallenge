//
//  Endpoint.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

enum Networks {
    case jsonPlaceHolder
    case openai
    case cryptoCompare
}
/// A protocol that represents an endpoint in a REST API
protocol Endpoint {

    /// The base URL for the endpoint
    var url: String { get }

    /// The path for the endpoint, relative to the base URL
    var path: String { get }

    /// The HTTP method for the endpoint (e.g. GET, POST, PUT, DELETE)
    var method: RequestMethod { get }

    /// An optional dictionary containing the body of the request
    var body: [String: Any]? { get }

    /// An optional dictionary containing the query parameters for the request
    var parameters: [URLQueryItem]? { get }

    // Determines the api to target
    var network: Networks { get }
}

extension Endpoint {

    var url: String {
        switch network {
        case .jsonPlaceHolder:
            return "https://jsonplaceholder.typicode.com/"
        case .openai:
            return "https://api.openai.com/"
        case .cryptoCompare:
            return "https://min-api.cryptocompare.com/data/"
        }
    }

    var headers: [String: String] {
        let defaults: [String: String] = ["Content-Type": "application/json"]
        switch network {
        case .openai:
            return defaults.comb(
                dict: ["Authorization": Environment.Key.bearer(key: .openai).value]
            )
        case .cryptoCompare:
            return defaults.comb(
                dict: ["Authorization": Environment.Key.apikey(key: .cryptoCompare).value]
            )
        default: return defaults
        }
    }
}
