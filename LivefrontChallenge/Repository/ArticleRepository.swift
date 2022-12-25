//
//  ArticleRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation

struct Article {
    let category: String?
    let document: String?
}

protocol ArticleInterface {
    func generateSummaryArticle(articles: [String]) async
}

typealias ArticleDataRepository = OpenAIServiceable

class ArticleRepository: ObservableObject, ArticleInterface {

    private let service: OpenAIService

    @Published var categorySummary = [Article]()

    init(service: OpenAIService = OpenAIService()) {
        self.service = OpenAIService()
    }

    public func generateSummaryArticle(articles: [String]) async {
        let articles = articles.prefix(10).joined(separator: ",\n")
        let params = OpenAIRequestParams(
            model: "text-davinci-003",
            prompt: "Summeraize these articles with a headline: \(articles)",
            temperature: 0.5,
            max_tokens: 2048,
            top_p: 1,
            frequency_penalty: 0,
            presence_penalty: 0
        )

        let result = try! await service.getSummaries(requestParams: params)
        switch result {
        case .success(let article):
            print(article)
            guard let summary = article.choices.first else { return }
            print(summary)
            self.categorySummary = [Article(category: "", document: summary.text)]
        case .failure(let error):
            print(error)
        }
    }

}
