//
//  HTTPClient.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

/// Protocol for HTTPClient
protocol HTTPClient {

    /// Primary method for HTTPClient to send data to server
    /// - parameter endpoint: The `Endpoint` builds a contructor to seed a network request
    /// - parameter responseModel: The `T.Type` Pass it a codable model the client will serialize its results
    /// - returns: A response containing a `<T, RequestError>`
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> Result<T, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> Result<T, RequestError> {

        var request = URLComponents(string: endpoint.url + endpoint.path)!

        if let parameters = endpoint.parameters {
            request.queryItems = parameters
        }

        guard let url = request.url else { throw RequestError.invalidURL }

        var urlRequest = URLRequest(url: url)
        // urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers

        if let body = endpoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .sortedKeys)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    throw RequestError.decode
                }
                return .success(decodedResponse)
            case 401:
                throw RequestError.unauthorized
            default:
                throw RequestError.unknown
            }
        } catch URLError.Code.notConnectedToInternet {
            throw RequestError.offline
        }
    }

}
