//
//  Constants.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import SwiftUI

public enum Environment {

    enum Token: String {
        case openai = "123"
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
