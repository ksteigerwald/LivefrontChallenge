//
//  Feed.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 1/1/23.
//

import Foundation
import SwiftUI
import Combine

public class Feed: ObservableObject {

    public var list: [ArticleFeedItem] = []

    @Published public var isFeedItemLoaded: Bool = false

    public static let shared = Feed()
    private let repository: ArticleRepository
    var cancellables = Set<AnyCancellable>()

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
