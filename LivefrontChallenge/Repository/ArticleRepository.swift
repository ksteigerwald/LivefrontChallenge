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

    /// Fetches latest news articles
    func getLatestArticles(limit: Int) async -> AnyPublisher<Result<[ArticleFeedItem], Error>, Error>

    /// Generate a new article from a source and selected prompt
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

public class Articles: ObservableObject {

    @State public var list: [Article] = []
    @Published public var document: Article = .init()
    @Published public var generatedSummaryLoaded: Bool = false

    public static let shared = Articles()
    private let repository: ArticleRepository
    var cancellables = Set<AnyCancellable>()

    init(repository: ArticleRepository = ArticleRepository()) {
        self.repository = repository
    }

    public func generateSummaryArticle(category: NewsCategory, articles: [Article]) {
        let urls = articles.map { $0.articleURL }
        guard !urls.isEmpty else { return }
        repository.generateSummaryArticle(category: category.name, articles: urls)
            .receive(on: RunLoop.main)
            .map(Result<OpenAIResponse, Error>.success)
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                switch result {
                case .success(let data):
                    guard let choice = data.choices.first else { return }
                    let article = Article(
                        category: category.name,
                        document: choice.text
                    )
                    self.document = article
                    self.generatedSummaryLoaded = true
                case .failure(let error):
                    print(error)
                }
            })
            .store(in: &cancellables)
    }

    func reset() {
        document = .init()
        generatedSummaryLoaded = false
        list = []
    }
}

@propertyWrapper
public struct ArticleProperty: DynamicProperty {
    @ObservedObject public var articles: Articles

    public init(articles: Articles = .shared) {
        self.articles = articles
    }
    public var wrappedValue: Articles {
        get {
            articles
        }

        mutating set {
            articles = newValue
        }
    }
}

@propertyWrapper
public struct SummaryArticle: DynamicProperty {
    @StateObject public var articles: Articles = Articles()
    @State var category: NewsCategory?

    public init(category: NewsCategory) {
        self.category = category
    }

    public var wrappedValue: [Article] {
        articles.list
    }

    public func update() {
        guard let category = category else { return }
        articles.generateSummaryArticle(category: category, articles: articles.list)
    }

}
