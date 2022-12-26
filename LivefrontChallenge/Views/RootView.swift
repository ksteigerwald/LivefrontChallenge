//
//  RootView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/26/22.
//

import Foundation
import SwiftUI

struct RootView: View {

    @EnvironmentObject var app: AppEnvironment
    @State private var isCategoriesLoaded = false
    @State private var path = NavigationPath()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.DesignSystem.greyscale900
            if isCategoriesLoaded {
                NavigationStack(path: $path) {
                    ZStack(alignment: .topLeading) {
                        mainContent
                    }
                    .ignoresSafeArea(.all)
                }
            } else {
                VStack {
                    Text("loading...")
                        .foregroundColor(Color.DesignSystem.primary100)
                        .font(Font.DesignSystem.headingH1)
                        .padding(.top, 200)

                }
            }
        }
        .task {
            do {
                await self.app.categories.fetchCategories()
                await self.app.articles.getLatestArticles()
                self.isCategoriesLoaded = true
            }
        }
    }

    var mainContent: some View {
        VStack(alignment: .leading) {
            MainHeadingView()
            RecommendationsView()
            NewsFeed()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding([.leading, .trailing], 20)
        .padding(.top, 100)
        .navigationBarHidden(true)
        .background(Color.DesignSystem.greyscale900)
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .home: RootView()
            case .detail(let category):
                ArticleSummaryView(
                    path: $path,
                    article: Article(
                        category: category,
                        document: ""
                    )
                )
                .environmentObject(AppEnvironment())
            case .article(let article):
                ArticleView(path: $path, article: article)
                    .environmentObject(AppEnvironment())
            }
        }
    }

}
