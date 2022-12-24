//
//  CryptoCompareRepository.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import Foundation

@MainActor
class CryptoCompareRepository: ObservableObject {
    let service: CryptoCompareService
    @Published var categories = [CryptoCompareNewsCategoriesResponse]()

    init(service: CryptoCompareService = CryptoCompareService()) {
        self.service = service
    }

    func fetchCategories() async {
        let result = try! await service.getNewsCategories()
        switch result {
        case .success(let categories):
            print(categories)
            self.categories = categories
        case .failure(let error):
            print("use toast or something \(error)")
        }
    }

}
