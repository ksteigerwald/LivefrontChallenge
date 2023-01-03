//
//  HTTPClient.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation
import Combine

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
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        // urlRequest.cachePolicy = .returnCacheDataElseLoad

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
                do {
                    let decoder = JSONDecoder()
                    // decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodeResponse = try decoder.decode(responseModel, from: data)
                    return .success(decodeResponse)
                } catch {
                    print(error)
                    throw RequestError.decode
                }
            case 401:
                throw RequestError.unauthorized
            case 400:
                throw RequestError.invalidRequest
            default:
                // TODO: HANDLER MODEL MAXIMUM
                throw RequestError.unknown
            }
        } catch URLError.Code.notConnectedToInternet {
            throw RequestError.offline
        }
    }

    func fetch<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) -> Publishers.Share<URLSession.DataTaskPublisher>? {
        var request = URLComponents(string: endpoint.url + endpoint.path)!

        if let parameters = endpoint.parameters {
            request.queryItems = parameters
        }

        guard let url = request.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        // urlRequest.cachePolicy = .returnCacheDataElseLoad

        if let body = endpoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .sortedKeys)
        }

        let sharedPublisher = URLSession.shared.dataTaskPublisher(for: url).share()

        let cancel1 = sharedPublisher
            .map { $0.data }
            .handleEvents(receiveSubscription: { _ in
                print("Started loading data")
            }, receiveOutput: { data in
                print(Double(data.count) / Double(200000000))
                // let currentProgress = Double(data.count) / Double(200000000)
                // self.updateProgress(currentProgress)
            }, receiveCompletion: { _ in
                print("Finished loading data")
            }, receiveCancel: {
                print("Cancelled loading data")
            })
            .eraseToAnyPublisher()
        return sharedPublisher
    }

}
