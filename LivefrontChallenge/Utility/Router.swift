//
//  Router.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import Foundation

enum Route: Hashable {
    case home
    case newsList
    case summaryView(NewsCategory)
    case article(NewsArticle)
}
