//
//  CryptoCompareService.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import Foundation

protocol CryptoCompareServiceable {

    /// Method for retrieving news from the CryptoCompare API
    /// - parameter requestParams: The `CryptoCompareRequestParams` struct containing parameters for the request
    /// - returns: A response containing a `CryptoCompareResponse` struct with the news articles for the provided parameters
    func getNews(requestParams: CryptoCompareRequestParams) async throws -> Result<CryptoCompareResponse, RequestError>
}

final class CryptoCompareService: HTTPClient, CryptoCompareServiceable {
    func getNews(requestParams: CryptoCompareRequestParams) async throws -> Result<CryptoCompareResponse, RequestError> {
        try await sendRequest(
            endpoint: CryptoCompareEndpoint.news(params: requestParams),
            responseModel: CryptoCompareResponse.self
        )
    }
}
