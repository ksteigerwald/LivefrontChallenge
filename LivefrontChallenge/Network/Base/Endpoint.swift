//
//  Endpoint.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

/// A protocol that represents an endpoint in a REST API
protocol Endpoint {
    
    /// The base URL for the endpoint
    var baseURL: String { get }
    
    /// The path for the endpoint, relative to the base URL
    var path: String { get }
    
    /// The HTTP method for the endpoint (e.g. GET, POST, PUT, DELETE)
    var method: RequestMethod { get }
    
    /// An optional dictionary containing the body of the request
    var body: [String: AnyObject]? { get }
    
    /// An optional dictionary containing the query parameters for the request
    var parameters: [String: String]? { get }
}
