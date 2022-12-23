//
//  OpenAIService.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

/// Protocol for interacting with the OpenAI API
protocol OpenAIServiceable {

    /// Method for retrieving summaries from the OpenAI API
    /// - parameter requestParams: The `OpenAIRequestParams` struct containing a list of URLs to summarize
    /// - returns: A response containing an `OpenAIResponse` struct with the summaries for the provided URLs
    func getSummaries(requestParams: OpenAIRequestParams) async throws -> Result<OpenAIResponse, RequestError>
}


final class OpenAIService: HTTPClient, OpenAIServiceable {
    func getSummaries(requestParams: OpenAIRequestParams) async throws -> Result<OpenAIResponse, RequestError> {
        try await sendRequest(
            endpoint: OpenAIEndpoint.documents(params: requestParams),
            responseModel: OpenAIResponse.self
        )
    }
}
