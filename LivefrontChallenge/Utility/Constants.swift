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
        case bearer(key: Token)
        case plain(Token)

        var value: String {
            switch self {
            case .bearer(let token):
                return "Bearer \(token.rawValue)"
            case .plain(let token):
                return token.rawValue
            }
        }
    }

    //ProcessInfo.processInfo.environment["OPENAI_KEY"] ?? "NOAPI-KEY-GIVEN"
}
