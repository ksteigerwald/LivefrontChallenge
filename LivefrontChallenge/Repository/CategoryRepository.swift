//
//  CategoryRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation
import Combine

/// A protocol that defines an interface for fetching news categories and news articles
protocol CategoryInterface {
    /// Fetches a list of news categories
    func fetchCategories() -> Future<[CryptoCompareNewsCategoriesResponse], Error>
    /// Fetches news articles for a specific category
    func fetchNewsForCategory(category: String) -> Future<CryptoCompareResponse, Error>
}

/// A concrete implementation of `CategoryInterface`
class CategoryRepository: CategoryInterface {
    private let ccService: CryptoCompareService

    /// Initializes a new instance of `CategoryRepository`
    init(ccService: CryptoCompareService = CryptoCompareService()) {
        self.ccService = ccService
    }

    /// Fetches news articles for a specific category
    func fetchNewsForCategory(category: String) -> Future<CryptoCompareResponse, Error> {
        let params = CryptoCompareRequestParams(
            categories: category
        )
        return Future(asyncFunc: {
            try await self.ccService.getNews(requestParams: params).get()
        })
    }

    /// Fetches a list of news categories
    func fetchCategories() -> Future<[CryptoCompareNewsCategoriesResponse], Error> {
        Future(asyncFunc: {
            try await self.ccService.getNewsCategories().get()
        })
    }
}
