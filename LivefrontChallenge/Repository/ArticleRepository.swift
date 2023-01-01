//
//  ArticleRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation
import Combine
import SwiftUI

protocol ArticleInterface {
    /// Generates a summary article for a given category and list of articles.
    /// - Parameters:
    ///   - category: The category for the summary article.
    ///   - articles: The list of articles to summarize.
    func generateSummaryArticle(category: String, articles: [String]) -> Future<OpenAIResponse, Error>

    /// Query for the latest articles from the News API.
    ///  - parameter limit: the number of articles to fetch
    ///  - returns: a `Future` containing a `CryptoCompareResponse` object or an `Error`
    func queryForArticles(limit: Int) -> Future<CryptoCompareResponse, Error>

    /// Generate an article from a prompt using OpenAI's API
    ///  - parameter prompt: the prompt to generate content from
    ///  - returns: a `Future` containing an `OpenAIResponse` object or an `Error`
    func generateArticleFromSource(prompt: Prompts) async -> Future<OpenAIResponse, Error>
}

/// A class for storing and managing articles.
public class ArticleRepository: ObservableObject, ArticleInterface {
    /// The OpenAI service to use for generating article summaries.
    private let service: OpenAIService
    /// News service used to gather crypto related news feeds
    private let newsService: CryptoCompareService

    /// Initializes a new `ArticleRepository` with the given OpenAI service.
    /// - Parameters:
    ///   - service:  The OpenAI service to use for generating article summaries.
    ///   - newsService: News service used to gather crypto related news feeds
    init(
        service: OpenAIService = OpenAIService(),
        newsService: CryptoCompareService = CryptoCompareService()
    ) {
        self.service = service
        self.newsService = newsService
    }

    public func generateSummaryArticle(category: String, articles: [String]) -> Future<OpenAIResponse, Error> {
        let articles = articles.prefix(10).joined(separator: ",\n")
        let params = OpenAIRequestParams(
            model: Prompts.Models.davinci003.rawValue,
            prompt: Prompts.summarizeWithHeadline(context: articles).value,
            temperature: 0.5,
            max_tokens: 2048,
            top_p: 1,
            frequency_penalty: 0,
            presence_penalty: 0
        )
        return Future(asyncFunc: {
            try await self.service.getSummaries(requestParams: params).get()
        })
    }

    func queryForArticles(limit: Int = 5) -> Future<CryptoCompareResponse, Error> {
        let params = CryptoCompareRequestParams()
        return Future(asyncFunc: {
            try await self.newsService.getNews(requestParams: params).get()
        })
    }

    func generateArticleFromSource(prompt: Prompts) -> Future<OpenAIResponse, Error> {
        let params = OpenAIRequestParams(
            model: Prompts.Models.davinci003.rawValue,
            prompt: prompt.value,
            temperature: 0.5,
            max_tokens: 4000,
            top_p: 1,
            frequency_penalty: 0,
            presence_penalty: 0
        )
        return Future(asyncFunc: {
            try await self.service.getSummaries(requestParams: params).get()
        })
    }
}
