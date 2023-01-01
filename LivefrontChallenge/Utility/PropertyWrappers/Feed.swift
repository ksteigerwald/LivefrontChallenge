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
public class Feed: ObservableObject {

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
                receiveCompletion: {_ in },
                receiveValue: { response in
                    switch response {
                    case .success(let data):
                        self.list = data.articles
                        self.isFeedItemLoaded = true
                    case .failure(let error):
                        print(error)
                    }
                })
            .store(in: &cancellables)
    }

}
/// A `FeedProperty` is a `DynamicProperty` that wraps a `Feed` object
/// - Parameters:
///   - feed: The `Feed` object to be wrapped. Defaults to `.shared`
/// - Example Usage:
///     ```
///     @FeedProperty var feed: Feed = .shared
///     ```
@propertyWrapper
public struct FeedProperty: DynamicProperty {
    @ObservedObject public var feed: Feed

    public init(feed: Feed = .shared) {
        self.feed = feed
    }

    public var wrappedValue: Feed {
        get {
            feed
        }

        mutating set {
            feed = newValue
        }
    }
}
