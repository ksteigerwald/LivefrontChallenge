//
//  ArticleRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation
import Combine

protocol ArticleInterface {
    /// Generates a summary article for a given category and list of articles.
    /// - Parameters:
    ///   - category: The category for the summary article.
    ///   - articles: The list of articles to summarize.
    func generateSummaryArticle(category: String, articles: [String]) -> Future<OpenAIResponse, Error>

    /// Fetches latest news articles
    func getLatestArticles(limit: Int) async -> AnyPublisher<Result<[ArticleFeedItem], Error>, Error>

    /// Generate a new article from a source and selected prompt
    func generateArticleFromSource(prompt: Prompts) async -> Future<OpenAIResponse, Error>
}

/// Typealias for an OpenAI service that can be used by `ArticleRepository`
typealias ArticleDataRepository = OpenAIServiceable

/// A class for storing and managing articles.
class ArticleRepository: ObservableObject, ArticleInterface {
    /// The OpenAI service to use for generating article summaries.
    private let service: OpenAIService

    private let newsService: CryptoCompareService

    /// Initializes a new `ArticleRepository` with the given OpenAI service.
    ///
    /// - Parameter service: The OpenAI service to use for generating article summaries.
    init(
        service: OpenAIService = OpenAIService(),
        newsService: CryptoCompareService = CryptoCompareService()
    ) {
        self.service = service
        self.newsService = newsService
    }

    /// Generates a summary article for the given category and list of articles.
    /// - Parameters:
    ///   - category: The category of the articles.
    ///   - articles: The list of articles to summarize.
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
    /// Query for the latest articles from the News API.
    ///  - parameter limit: the number of articles to fetch
    ///  - returns: a `Future` containing a `CryptoCompareResponse` object or an `Error`
    func queryForArticles(limit: Int = 5) -> Future<CryptoCompareResponse, Error> {
            let params = CryptoCompareRequestParams()
        return Future(asyncFunc: {
            try await self.newsService.getNews(requestParams: params).get()
        })
    }

    /// Get the latest articles from the News API
    /// - parameter limit: the number of articles to fetch
    /// - returns: a publisher emitting a `Result` containing an array of `ArticleFeedItem` objects or an `Error`
    func getLatestArticles(limit: Int = 5) -> AnyPublisher<Result<[ArticleFeedItem], Error>, Error> {
        queryForArticles()
            .map { Result.success($0.articles) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    /// Get content from OpenAI's API
    /// - parameter prompt: the prompt to generate content from
    /// - returns: a publisher emitting a `Result` containing an `Article` object or an `Error`
    func getAIContent(prompt: Prompts) -> AnyPublisher<Result<Article, Error>, Error> {
        generateArticleFromSource(prompt: prompt)
            .map { $0.choices[0] }
            .map { Article(category: "Summary", document: $0.text)}
            .map { Result.success($0)}
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    /// Generate an article from a prompt using OpenAI's API
    ///  - parameter prompt: the prompt to generate content from
    ///  - returns: a `Future` containing an `OpenAIResponse` object or an `Error`
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
