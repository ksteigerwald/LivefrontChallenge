//
//  Categories.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 1/1/23.
//

import Foundation
import Combine
import SwiftUI

protocol StateManagerProtocol {
    var error: Error? { get set }
    var isError: Bool { get set }
    var isLoading: Bool { get set }
    func handleResponse<T>(response: Result<T, Error>)
}

/// The `Categories` class provides access to the list of NewsCategories and Articles related to a particular category. It provides methods to fetch the list of categories and articles for a particular category.
///
/// - Parameters:
///   - repository: The CategoryRepository object to use for fetching categories and articles.
///
/// - Remark:
///   The `Categories` class is a singleton and should be accessed via the `shared` static property.
public class Categories: ObservableObject, StateManagerProtocol {

    @Published var isError: Bool = false

    @Published var error: Error?

    @Published var isLoading: Bool = false

    /// `list` - An array of `NewsCategory` objects, available as a published property.
    @Published public var list: [NewsCategory] = []

    /// `news` - An array of `Article` objects, available as a published property.
    @Published public var news: [Article] = []

    /// `shared` - A singleton instance of the `Categories` class.
    public static let shared = Categories()

    /// `repository` - A `CategoryRepository` object used to interact with the category repository.
    private let repository: CategoryRepository

    /// `cancellables` - A set of `AnyCancellable` objects used to manage requests.
    var cancellables = Set<AnyCancellable>()

    /// `init(repository: CategoryRepository = CategoryRepository())` - Initializes the `Categories` class with a given `CategoryRepository`. If none is provided, a default `CategoryRepository` is instantiated.
    init(repository: CategoryRepository = CategoryRepository()) {
        self.repository = repository
        fetchCategories()
    }

    /// `fetchCategories()` - Fetches the categories from the repository and assigns them to the `list` property.
    public func fetchCategories() {
        repository.fetchCategories()
            .receive(on: RunLoop.main)
            .map(Result<[CryptoCompareNewsCategoriesResponse], Error>.success)
            .sink(receiveCompletion: {_ in}, receiveValue: { result in
                switch result {
                case .success(let data):
                    self.list = data
                        .filter { $0.categoryName.count < 5 }
                        .map { NewsCategory(name: $0.categoryName)}
                    self.handleResponse(response: .success(data))
                case .failure(let error):
                    self.handleResponse(response: Result<NewsCategory, Error>.failure(error))
                }
            })
            .store(in: &cancellables)
    }

    /// Gets news from a specified news category.
    ///
    /// - Parameter category: The news category from which to get news.
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
                case .failure(let error):
                    self.handleResponse(response: Result<NewsCategory, Error>.failure(error))
                }
            })
            .store(in: &cancellables)
    }

    func handleResponse<T>(response: Result<T, Error>) {
        switch response {
        case .success:
            self.error = nil
            self.isLoading = false
        case .failure(let error):
            self.error = error
            self.isLoading = false
        }
    }
}
/// This struct provides a property wrapper for the `Categories` class.
///
/// - `@propertyWrapper`: A property wrapper type that provides read and write access to a value of type
@propertyWrapper
public struct CategoryProperty: DynamicProperty {

    /// - `@ObservedObject`: The `@ObservedObject` attribute specifies that the property should be observed
    @ObservedObject public var categories: Categories

    /// - `public var wrappedValue`: The read/write property used to access the value of type `Categories`.
    public var wrappedValue: Categories {
        get {
            categories
        }

        mutating set {
            categories = newValue
        }
    }
    /// - `public init`: Initializes a new instance of `CategoryProperty` with an optional `Categories` parameter. If no parameter is supplied, the shared `Categories` instance will be used.
    public init(categories: Categories = .shared) {
        self.categories = categories
    }
}
