//
//  CategoryRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation
import Combine

struct NewsCategory: Hashable {
    let name: String
}

protocol CategoryInterface {
    func fetchCategories() async -> Result<[NewsCategory], Error>
    func fetchNewsForCategory(category: String) async -> Future<CryptoCompareResponse, Error>
}

typealias CategoryDataRepository = CryptoCompareServiceable

class CategoryRepository: CategoryInterface {
    private let ccService: CryptoCompareService

    init(ccService: CryptoCompareService = CryptoCompareService()) {
        self.ccService = ccService
    }

    func fetchNewsForCategory(category: String) -> Future<CryptoCompareResponse, Error> {
        let params = CryptoCompareRequestParams(
            categories: category
        )
        return Future(asyncFunc: {
            try await self.ccService.getNews(requestParams: params).get()
        })
    }

    @MainActor
    func fetchCategories() async -> Result<[NewsCategory], Error> {
        do {
            let result = try await ccService.getNewsCategories()

            switch result {
            case .success(let data):
                let categories = data.map {
                    NewsCategory(name: $0.categoryName)
                }
                return .success(categories)
            case .failure(let error):
                return .failure(error)
            }
        } catch let error {
            return .failure(error)
        }
    }
}
