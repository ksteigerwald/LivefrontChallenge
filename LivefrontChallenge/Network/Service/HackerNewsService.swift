//
//  HackerNewsService.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/27/22.
//

import Foundation

struct HNTopStoriesResponse: Decodable {
    let story: [Int]
}

struct HNGetNewsItemResponse: Codable {
    let by: String
    let descendants: Int
    let id: Int
    let kids: [Int]
    let score: Int
    let time: Int
    let title: String
    let type: String
    let url: String
}

protocol HackerNewsServiceable {
    func getTopStories() async throws -> Result<[HNTopStoriesResponse], RequestError>
    func getnewsItem(id: Int) async throws -> Result<HNGetNewsItemResponse, RequestError>
}

final class HackerNewsService: HTTPClient, HackerNewsServiceable {
    func getTopStories() async throws -> Result<[HNTopStoriesResponse], RequestError> {
        try await sendRequest(endpoint: HackerNewsEndpoint.topStories, responseModel: [HNTopStoriesResponse].self)
    }

    func getnewsItem(id: Int) async throws -> Result<HNGetNewsItemResponse, RequestError> {
        try await sendRequest(endpoint: HackerNewsEndpoint.newsItem(article: id), responseModel: HNGetNewsItemResponse.self)
    }
}
