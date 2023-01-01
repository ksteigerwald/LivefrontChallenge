//
//  Categories.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 1/1/23.
//

import Foundation
import Combine
import SwiftUI

public class Categories: ObservableObject {

    @Published public var list: [NewsCategory] = []
    @Published public var news: [Article] = []

    public static let shared = Categories()
    private let repository: CategoryRepository
    var cancellables = Set<AnyCancellable>()

    init(repository: CategoryRepository = CategoryRepository()) {
        self.repository = repository
        fetchCategories()
    }

    public func fetchCategories() {
        repository.fetchCategories()
            .receive(on: RunLoop.main)
            .map(Result<[CryptoCompareNewsCategoriesResponse], Error>.success)
            .sink(receiveCompletion: {_ in}, receiveValue: { result in
                switch result {
                case .success(let data):
                    self.list = data.map { NewsCategory(name: $0.categoryName)}
                case .failure(let error):
                    print(error)
                }
            })
            .store(in: &cancellables)
    }

    public func getNewsFromCategory(category: NewsCategory) {
        repository.fetchNewsForCategory(category: category.name)
            .receive(on: RunLoop.main)
            .map(Result<CryptoCompareResponse, Error>.success)
            .sink(receiveCompletion: {_ in}, receiveValue: { result in
                switch result {
                case .success(let data):
                    self.news = Array(data.articles.map {
                        Article(
                            category: category.name,
                            headline: $0.title,
                            articleURL: $0.url
                        )
                    }.prefix(10))
                    print(self.news.count)
                case .failure(let error):
                    print(error)
                }
            })
            .store(in: &cancellables)
    }
}

@propertyWrapper
public struct CategoryProperty: DynamicProperty {
    @ObservedObject public var categories: Categories

    public var wrappedValue: Categories {
        get {
            categories
        }

        mutating set {
            categories = newValue
        }
    }

    public init(categories: Categories = .shared) {
        self.categories = categories
    }
}
