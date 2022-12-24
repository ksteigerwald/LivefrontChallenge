//
//  Environment.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation

public enum Environment {

    enum Token: String {
        case openai = "123"
        case cryptoCompare = "a123"
    }

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
