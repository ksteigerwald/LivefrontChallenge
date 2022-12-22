//
//  JSONPlaceHolderService.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

protocol JSONPlaceHolderServiceable {
    func getPosts(article: Int) async throws -> Result<JSONPlaceHolderResponse, RequestError>
}

final class JSONPlaceHolderService: HTTPClient, JSONPlaceHolderServiceable {
    func getPosts(article: Int) async throws -> Result<JSONPlaceHolderResponse, RequestError> {
        try await sendRequest(endpoint: JSONPlaceHolderEndpoint.getTest, responseModel: JSONPlaceHolderResponse.self)
    }
}
