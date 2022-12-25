//
//  ArticleRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation

extension String {
    func parseHeadlineAndBody() -> [String]? {
        let filtered = (self as NSString).components(separatedBy: "\n").filter { element in
            return element.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        }
        guard filtered.count >= 2 else { return nil }
        return filtered
    }
}


struct Article {
    let category: String?
    let document: String?
    let headline: String?
    let body: String?

    init(
        category: String = "",
        document: String = "",
        headline: String? = nil,
        body: String? = nil
    ) {
        self.category = category
        self.document = document
        let news = document.parseHeadlineAndBody()
        self.headline = news?.first ?? ""
        self.body = news?.last ?? ""
    }
}

protocol ArticleInterface {
    func generateSummaryArticle(category: String, articles: [String]) async
}

typealias ArticleDataRepository = OpenAIServiceable

class ArticleRepository: ObservableObject, ArticleInterface {

    private let service: OpenAIService

    @Published var categorySummary = [Article]()

    init(service: OpenAIService = OpenAIService()) {
        self.service = OpenAIService()
    }

    public func generateSummaryArticle(category: String, articles: [String]) async {
        let articles = articles.prefix(10).joined(separator: ",\n")
        let params = OpenAIRequestParams(
            model: "text-davinci-003",
            prompt: "Summeraize these articles, include a headline for the summary: \(articles)",
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
            self.categorySummary = [Article(category: category, document: summary.text)]
        case .failure(let error):
            print(error)
        }
    }

}
