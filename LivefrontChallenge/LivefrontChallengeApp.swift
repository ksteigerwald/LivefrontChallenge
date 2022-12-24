//
//  LivefrontChallengeApp.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import SwiftUI

enum Route: Hashable {
    case home
    case detail(AIArticle)
}

@main
struct LivefrontChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            // When testing do not run the whole app in order to speed up things
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                EmptyView()
            } else {
                NavigationStack {
                    ContentView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .home: ContentView()
                            case .detail(let article):
                                ArticleView(article: article)
                            }
                        }
                }
            }
        }
    }
}
