//
//  Articles.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 1/1/23.
//

import Foundation
import Combine
import SwiftUI

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
