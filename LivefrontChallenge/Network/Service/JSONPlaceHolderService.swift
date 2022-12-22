//
//  JSONPlaceHolderService.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

protocol JSONPlaceHolderServiceable {
    func getPosts(article: Int) async -> Result<JSONPlaceHolderResponse, RequestError>
}

final class JSONPlaceHolderService: HTTPClient, JSONPlaceHolderServiceable {
    func getPosts(article: Int) async -> Result<JSONPlaceHolderResponse, RequestError> {
        
    }


}
