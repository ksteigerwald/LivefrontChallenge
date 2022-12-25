//
//  ArticleRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation

struct Article {
    let category: String
    let document: String
    let headline: String
    let body: String

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
        body: String? = nil
    ) {
        self.category = category
        self.document = document
        let news = document.parseHeadlineAndBody()
        self.headline = news?.first ?? document
        self.body = news?.last ?? document
    }
}

protocol ArticleInterface {
    /// Generates a summary article for a given category and list of articles.
    /// - Parameters:
    ///   - category: The category for the summary article.
    ///   - articles: The list of articles to summarize.
    func generateSummaryArticle(category: String, articles: [String]) async
}

/// Typealias for an OpenAI service that can be used by `ArticleRepository`
typealias ArticleDataRepository = OpenAIServiceable

/// A class for storing and managing articles.
class ArticleRepository: ObservableObject, ArticleInterface {

    /// The OpenAI service to use for generating article summaries.
    private let service: OpenAIService

    /// A published array of articles, which will be used to update views that are observing this object.
    @Published var categorySummary = [Article]()

    /// Initializes a new `ArticleRepository` with the given OpenAI service.
    ///
    /// - Parameter service: The OpenAI service to use for generating article summaries.
    init(service: OpenAIService = OpenAIService()) {
        self.service = OpenAIService()
    }

    /// Generates a summary article for the given category and list of articles.
    ///
    /// - Parameters:
    ///   - category: The category of the articles.
    ///   - articles: The list of articles to summarize.
    public func generateSummaryArticle(category: String, articles: [String]) async {
        let articles = articles.prefix(10).joined(separator: ",\n")
        let params = OpenAIRequestParams(
            model: Environment.AI.Models.davinci003.rawValue,
            prompt: Environment.AI.Prompts.summarizeWithHeadline(context: articles).value,
            temperature: 0.5,
            max_tokens: 2048,
            top_p: 1,
            frequency_penalty: 0,
            presence_penalty: 0
        )

        let result = try! await service.getSummaries(requestParams: params)
        switch result {
        case .success(let article):
            guard let summary = article.choices.first else { return }
            self.categorySummary = [Article(category: category, document: summary.text)]
        case .failure(let error):
            print(error)
        }
    }

}
