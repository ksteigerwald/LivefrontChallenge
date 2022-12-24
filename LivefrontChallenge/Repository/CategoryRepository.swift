//
//  CategoryRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation
import Combine

struct NewsCategory {
    let name: String
}

protocol CategoryInterface {
    func fetchCategories() async
}

typealias CategoryDataRepository = CryptoCompareServiceable

class CategoryRepository: ObservableObject, CategoryInterface {

    @Published var categories = [NewsCategory]() {
        didSet {
            assembleRecomendations()
        }
    }
    @Published var recommendations = [NewsCategory]()

    private let ccService: CryptoCompareService
    private var cancellables = [AnyCancellable]()

    init(ccService: CryptoCompareService = CryptoCompareService()) {
        self.ccService = ccService
    }

    @MainActor
    func fetchCategories() async  {
        let result = try! await ccService.getNewsCategories()

        switch result {
        case .success(let data):
            self.categories = data.map {
                let val = NewsCategory(name: $0.categoryName)
                return val
            }

        case .failure(let error):
            print(error)
            //TODO: handle error
            return
        }
    }

    private func assembleRecomendations() {
        // TODO: Store selected articles and related categories
        print(categories)
        recommendations = categories.filter { ["XRP", "ETH", "ALGO", "BTC", "XLM"].contains($0.name) }
    }
}