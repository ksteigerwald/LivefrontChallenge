//
//  ArticleRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation
import Combine

struct Article {
    let category: String
    let document: String
    let headline: String
    let body: String
    let articleURL: String
    let imageURL: String
    /// Initializes an `Article` instance.
    /// - Parameters:
    ///   - category: The category of the article.
    ///   - document: The document containing the headline and body of the article.
    ///   - headline: (Optional) The headline of the article. If not provided, the first line of the `document` will be used.
    ///   - body: (Optional) The body of the article. If not provided, the second line of the `document` will be used.
    init(
        category: String = "",
        document: String = "",
        headline: String? = nil,
        body: String? = nil,
        articleURL: String = "",
        imageURL: String = "https://placeimg.com/320/240/any"
    ) {
        var content: [String] = document.parseHeadlineAndBody()
        self.category = category
        self.document = document
        self.imageURL = imageURL
        self.articleURL = articleURL
        self.headline = content.remove(at: 0)
        self.body = content.joined(separator: "\n\n")
    }
}

protocol ArticleInterface {
    /// Generates a summary article for a given category and list of articles.
    /// - Parameters:
    ///   - category: The category for the summary article.
    ///   - articles: The list of articles to summarize.
    func generateSummaryArticle(category: String, articles: [String]) -> Future<OpenAIResponse, Error>

    /// Fetches latest news articles
    func getLatestArticles(limit: Int) async -> AnyPublisher<Result<[NewsArticle], Error>, Error>

    /// Generate a new article from a source and selected prompt
    func generateArticleFromSource(prompt: Prompts) async -> Result<Article, Error>
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

    func queryForArticles(limit: Int = 5) -> Future<CryptoCompareResponse, Error> {
            let params = CryptoCompareRequestParams()
        return Future(asyncFunc: {
            try await self.newsService.getNews(requestParams: params).get()
        })
    }
    /// get the latest news articles
    func getLatestArticles(limit: Int = 5) -> AnyPublisher<Result<[NewsArticle], Error>, Error> {
        queryForArticles()
            .map { Result.success($0.articles) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func generateArticleFromSource(prompt: Prompts) async -> Result<Article, Error> {
        let params = OpenAIRequestParams(
            model: Prompts.Models.davinci003.rawValue,
            prompt: prompt.value,
            temperature: 0.5,
            max_tokens: 4000,
            top_p: 1,
            frequency_penalty: 0,
            presence_penalty: 0
        )

        do {
            let result = try await service.getSummaries(requestParams: params)
            switch result {
            case .success(let article):
                guard let summary = article.choices.first else {
                    return .failure(RequestError.decode)
                }

                return .success(Article(
                    category: "Summary",
                    document: summary.text
                ))
            case .failure(let error):
                return .failure(error)
            }
        } catch let error {
            return .failure(error)
        }
    }
}
