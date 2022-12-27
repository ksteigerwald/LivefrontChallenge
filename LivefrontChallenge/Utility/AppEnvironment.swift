//
//  AppEnvironment.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation

class AppEnvironment: ObservableObject {

    @Published var categories = CategoryRepository()
    @Published var articles = ArticleRepository()
}
