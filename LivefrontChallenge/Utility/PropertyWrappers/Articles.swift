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

    public static let shared = Articles()

    @State public var list: [Article] = []
    @Published public var generatedSummaryLoaded: Bool = false
    @Published public var isLoaded: Bool = false

    public var firstLoad: Bool = false
    public var generatedContent: Article = .init()
    public var document: Article = .init()
    public var cached: Article?

    private let repository: ArticleRepository
    var cancellables = Set<AnyCancellable>()

    init(repository: ArticleRepository = ArticleRepository()) {
        self.repository = repository
    }

    public func generateSummaryArticle(category: NewsCategory, articles: [Article]) {
        let urls = articles.map { $0.articleURL }
        guard let image = articles.first?.imageURL else { return }
        guard !urls.isEmpty else { return }
        repository.generateSummaryArticle(category: category.name, articles: urls)
            .receive(on: RunLoop.main)
            .map(Result<OpenAIResponse, Error>.success)
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                switch result {
                case .success(let data):
                    guard let choice = data.choices.first else { return }
                    guard let content = choice.text.parseHeadlineAndBody() else { return }
                    let article = Article(
                        category: category.name,
                        headline: content.headline,
                        body: content.body,
                        imageURL: image
                    )
                    self.document = article
                    self.generatedSummaryLoaded = true
                case .failure(let error):
                    print(error)
                }
            })
            .store(in: &cancellables)
    }

    public func generateArticleFromPrompt(prompt: Prompts) {
        repository.generateArticleFromSource(prompt: prompt)
            .receive(on: RunLoop.main)
            .map(Result<OpenAIResponse, Error>.success)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    switch result {
                    case .success(let data):
                        guard let val = Array(data.choices.prefix(1)).first else { return }
                        guard let content = val.text.parseHeadlineAndBody() else { return }
                        var heading: String = ""
                        // TODO: this is way too ask not tell.
                        if case .toneAnalysis = prompt {
                            heading = self.cached!.headline
                        }

                        let article = Article(
                            headline: heading.isEmpty ? content.headline : heading,
                            body: content.body
                        )
                        self.generatedContent = article
                        self.isLoaded = true

                    case .failure(let error):
                        print(error)
                    }
                })
            .store(in: &cancellables)
    }

    func cacheHadler(item: ArticleFeedItem) {
        if !firstLoad && cached == nil {
            self.firstLoad = true
            let cacheArticle = Article(
                headline: generatedContent.headline,
                body: generatedContent.body,
                articleURL: item.url,
                imageURL: item.imageUrl
            )
            self.cached = cacheArticle
        }
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
