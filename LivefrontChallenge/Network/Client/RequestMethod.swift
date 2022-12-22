//
//  RequestMethod.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

/// An enum that represents an HTTP request method.
enum RequestMethod: String {
    
    /// The DELETE request method.
    case delete = "DELETE"
    
    /// The GET request method.
    case get = "GET"
    
    /// The PATCH request method.
    case patch = "PATCH"
    
    /// The POST request method.
    case post = "POST"
    
    /// The PUT request method.
    case put = "PUT"
}
