//
//  Environment.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation

/// The Environment enum contains all the necessary environment variables and keys for making network requests to the OpenAI and CryptoCompare APIs.
public enum Environment {

    /// The Token enum represents the different keys that are needed to make requests to the APIs. Each token is associated with a string value.
    enum Token: String {
        /// OpenAI Key goes here
        case openai = "123"
        /// CryptoCompare Key goes here
        case cryptoCompare = "a123"
    }

    /// The `Key` enum represents the different types of keys that are used to authenticate network requests.
    enum Key {
        case apikey(key: Token)
        case bearer(key: Token)
        case plain(Token)

        var value: String {
            switch self {
            case .apikey(let token):
                return "Apikey \(token.rawValue)"
            case .bearer(let token):
                return "Bearer \(token.rawValue)"
            case .plain(let token):
                return token.rawValue
            }
        }
    }
}
