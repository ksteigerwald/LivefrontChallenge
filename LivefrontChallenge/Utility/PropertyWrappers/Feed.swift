//
//  Feed.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 1/1/23.
//

import Foundation
import SwiftUI
import Combine
/// A class for managing the feed of articles
///
/// This class handles retrieving articles from the `ArticleRepository` and managing their state.
public class Feed: ObservableObject, StateManagerProtocol {

    @Published var error: Error?

    @Published var isError: Bool = false

    @Published var isLoading: Bool = true

    /// An array of articles contained in the feed
    public var list: [ArticleFeedItem] = []

    /// Boolean value for tracking whether the feed items have been loaded
    @Published public var isFeedItemLoaded: Bool = false

    /// The shared instance of the `Feed` class
    public static let shared = Feed()

    /// The repository used to retrieve articles
    private let repository: ArticleRepository

    /// A set of `AnyCancellable` to manage cancellable operations
    var cancellables = Set<AnyCancellable>()

    /// Initializer for the `Feed` class
    ///
    /// - Parameters:
    ///   - repository: The `ArticleRepository` used to retrieve articles.
    init(repository: ArticleRepository = ArticleRepository()) {
        self.repository = repository
    }

    func getLatestArticles(limit: Int = 5) {
        repository.queryForArticles()
            .receive(on: RunLoop.main)
            .map(Result<CryptoCompareResponse, Error>.success)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.handleResponse(response: Result<ArticleFeedItem, Error>.failure(error))
                    default: print(completion)
                    }
                },
                receiveValue: { response in
                    switch response {
                    case .success(let data):
                        self.list = data.articles
                        self.handleResponse(response: .success(data.articles))
                    case .failure(let error):
                        self.handleResponse(response: Result<ArticleFeedItem, Error>.failure(error))
                    }
                })
            .store(in: &cancellables)
    }

    func handleResponse<T>(response: Result<T, Error>) {
        switch response {
        case .success:
            self.error = nil
            self.isLoading = false
            self.isFeedItemLoaded = true
        case .failure(let error):
            self.error = error
            self.isLoading = false
            self.isFeedItemLoaded = false
        }
    }
}

/// A property wrapper for the Feed type.
/// - Note: FeedProperty provides a wrapper for the `Feed` type.
/// - Parameters:
///   - feed: The Feed object used for the property wrapper.
/// - Returns: A FeedProperty object.
@propertyWrapper
public struct FeedProperty: DynamicProperty {
    /// The observed object for the FeedProperty.
    @ObservedObject public var feed: Feed

    /// Creates a FeedProperty object.
    /// - Parameters:
    ///   - feed: The Feed object used for the property wrapper.
    public init(feed: Feed = .shared) {
        self.feed = feed
    }

    /// Returns the wrapped value of the FeedProperty object.
    public var wrappedValue: Feed {
        get {
            feed
        }

        /// Sets the wrapped value of the FeedProperty object.
        mutating set {
            feed = newValue
        }
    }
}
