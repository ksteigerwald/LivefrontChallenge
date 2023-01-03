//
//  Articles.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 1/1/23.
//

import Foundation
import Combine
import SwiftUI

/// Articles is an ObservableObject that is responsible for loading and generating articles.
/// It uses a repository to fetch data and uses a property wrapper to be a part of the SwiftUI environment.
public class Articles: ObservableObject, StateManagerProtocol {

    @Published var error: Error?

    @Published var isError: Bool = false

    @Published var isLoading: Bool = true

    @Published var isLoaded: Bool = false

    /// A shared instance of Articles that is used to be accessed throughout the app.
    public static let shared = Articles()

    /// A list of articles that is used to store and display data.
    @State public var list: [Article] = []

    /// A boolean value that indicates whether the summary article has been loaded.
    @Published public var generatedSummaryLoaded: Bool = false

    /// A boolean value that is used to check if the app has been loaded for the first time.
    public var firstLoad: Bool = false

    /// An article object that stores generated data.
    public var generatedContent: Article = .init()

    /// An article object that stores the summary article.
    public var document: Article = .init()

    /// An optional article object that stores cached data.
    public var cached: Article?

    /// An instance of ArticleRepository used to fetch data.
    private let repository: ArticleRepository

    /// A set of cancellables used to cancel ongoing tasks.
    var cancellables = Set<AnyCancellable>()

    /// Initializes a new instance of `Articles` with a repository.
    /// - Parameters:
    ///   - repository: An instance of ArticleRepository used to fetch data.
    init(repository: ArticleRepository = ArticleRepository()) {
        self.repository = repository
    }

    /// Generates a summary article from a list of articles and a category.
    /// - Parameters:
    ///   - category: The category for the summary article.
    ///   - articles: A list of articles to generate the summary from.
    public func generateSummaryArticle(category: NewsCategory, articles: [Article]) {
        let urls = articles.map { $0.articleURL }
        guard let image = articles.first?.imageURL else { return }
        guard !urls.isEmpty else { return }
        repository.generateSummaryArticle(category: category.name, articles: urls)
            .receive(on: RunLoop.main)
            .map(Result<OpenAIResponse, Error>.success)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.handleResponse(response: Result<Article, Error>.failure(error))
                    default: print(completion)
                    }
                }, receiveValue: { result in
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
                        self.handleResponse(response: .success(article))
                    case .failure(let error):
                        self.handleResponse(response: Result<Article, Error>.failure(error))
                    }
                })
            .store(in: &cancellables)
    }

    /// Generates an article from a prompt and caches it if successful.
    ///
    /// - Parameters:
    ///   - prompt: The `Prompts` associated with the article to generate.
    ///   - item: The `ArticleFeedItem` associated with the article.
    ///
    /// - Returns: An `Article` if successful, `nil` otherwise.
    public func generateArticleFromPrompt(prompt: Prompts) {
        repository.generateArticleFromSource(prompt: prompt)
            .receive(on: RunLoop.main)
            .map(Result<OpenAIResponse, Error>.success)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.handleResponse(response: Result<Article, Error>.failure(error))
                    default: print(completion)
                    }
                },
                receiveValue: { result in
                    switch result {
                    case .success(let data):
                        guard let val = Array(data.choices.prefix(1)).first else { return }
                        guard let content = val.text.parseHeadlineAndBody() else { return }
                        var heading: String = ""
                        // TODO: Compose a directive that encourages the listener to take action.
                        if case .toneAnalysis = prompt {
                            heading = self.cached!.headline
                        }

                        let article = Article(
                            headline: heading.isEmpty ? content.headline : heading,
                            body: content.body
                        )
                        self.generatedContent = article
                        self.handleResponse(response: .success(article))
                    case .failure(let error):
                        self.handleResponse(response: Result<Article, Error>.failure(error))
                    }
                })
            .store(in: &cancellables)
    }
    /// Caches the generated article content, only executed if the cache is empty and the first load has not yet been done.
    ///
    /// - Parameter item: The article feed item that contains the article's url and image url
    ///
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

    func handleResponse<T>(response: Result<T, Error>) {
        switch response {
        case .success:
            self.error = nil
            self.isLoading = false
            self.isError = false
            self.isLoaded = true
            self.firstLoad = false
        case .failure(let error):
            self.error = error
            self.isError = true
            self.isLoading = false
            self.isLoaded = false
            print("self.isError: \(self.isError)")
        }
    }
}

/// A property wrapper type that provides access to the `articles` instance.
/// - parameter articles: An instance of `Articles` that provides the initial value of the property.
@propertyWrapper
public struct ArticleProperty: DynamicProperty {
    /// An instance of `Articles` that stores the value of the property.
    @ObservedObject public var articles: Articles

    /// Initializes an instance of `ArticleProperty` with the specified `Articles` instance.
    /// - parameter articles: An instance of `Articles` that provides the initial value of the property.
    public init(articles: Articles = .shared) {
        self.articles = articles
    }

    /// Returns the `Articles` instance associated with the property.
    public var wrappedValue: Articles {
        get {
            articles
        }

        /// Sets the `Articles` instance associated with the property.
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
