//
//  RootView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/26/22.
//

import Foundation
import SwiftUI
import Combine

struct RootView: View {

    @EnvironmentObject var app: AppEnvironment
    @State private var path = NavigationPath()
    @State var articleFeedItems: [ArticleFeedItem]

    @State private var cancellables = [AnyCancellable]()

    @CategoryProperty var categories: Categories
    @FeedProperty var articles: Feed

    var body: some View {
        ZStack(alignment: .top) {
            Color.DesignSystem.greyscale900
            if articles.isFeedItemLoaded {
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
            articles.getLatestArticles()
        }
        .onReceive(articles.$isFeedItemLoaded) { _ in
            articleFeedItems = articles.list
            print(articleFeedItems)
        }
    }

    var mainContent: some View {
        VStack(alignment: .leading) {
            MainHeadingView()
            RecommendationsView(recomendations: categories.list)
            NewsFeed(articleFeedItems: $articleFeedItems)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding([.leading, .trailing], 20)
        .padding(.top, 100)
        .navigationBarHidden(true)
        .background(Color.DesignSystem.greyscale900)
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .home: RootView(articleFeedItems: [])
            case .summaryView(let category):
                ArticleSummaryView(
                    path: $path,
                    category: category
                )
                .environmentObject(AppEnvironment())
            case .article(let articleFeedItem):
                ArticleView(path: $path, articleFeedItem: articleFeedItem)
                    .environmentObject(AppEnvironment())
            case .newsList:
                NewsListView(path: $path)
            }
        }
    }

}
