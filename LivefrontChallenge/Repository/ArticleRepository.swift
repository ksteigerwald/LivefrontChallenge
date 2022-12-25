//
//  ArticleRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation

struct Article {
    let category: String?
}

protocol ArticleInterface {
    func generateSummaryArticle() async
}

typealias ArticleDataRepository = OpenAIServiceable

class ArticleRepository: ObservableObject, ArticleInterface {

    private let service: OpenAIService

    init(service: OpenAIService = OpenAIService()) {
        self.service = OpenAIService()
    }

    func generateSummaryArticle() async {
        let params = OpenAIRequestParams(
            model: "text-davinci-003",
            prompt: "Summeraize these articles:\nhttps://www.coindesk.com/business/2022/12/22/ftx-ask-judge-for-help-in-fight-over-robinhood-shares-worth-about-450m/?utm_medium=referral&utm_source=rss&utm_campaign=headlines,\n    \"https://cointelegraph.com/news/the-most-eco-friendly-blockchain-networks-in-2022",
            temperature: 0.5,
            max_tokens: 120,
            top_p: 1,
            frequency_penalty: 0,
            presence_penalty: 0
        )

        let result = try! await service.getSummaries(requestParams: params)
        switch result {
        case .success(let article):
            print(article)
        case .failure(let error):
            print(error)
        }
    }


}
