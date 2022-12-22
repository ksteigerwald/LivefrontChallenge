//
//  RequestError.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation
/// An enum that represents an error that can occur during a network request.
enum RequestError: Error {

    /// The error that occurs when the response cannot be decoded.
    case decode

    /// The error that occurs when the request is invalid.
    case invalidRequest

    /// The error that occurs when the URL is invalid.
    case invalidURL

    /// The error that occurs when there is no response from the server.
    case noResponse

    /// The error that occurs when the request is unauthorized.
    case unauthorized

    /// The error that occurs when the response has an unexpected status code.
    case unexpectedStatusCode

    /// The error that occurs when the cause of the error is unknown.
    case unknown

    /// The error that occurs when the headers are not set.
    case headersNotSet

    /// The error that occurs when there is no network connection
    case offline

    /// A custom message for the error.
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
