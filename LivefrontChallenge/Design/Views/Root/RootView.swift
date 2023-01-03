//
//  RootView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/26/22.
//

import Foundation
import SwiftUI
import Combine
import AlertToast

struct RootView: View {

    @State private var path = NavigationPath()

    @State var articleFeedItems: [ArticleFeedItem]

    @CategoryProperty var categories: Categories
    @FeedProperty var articles: Feed

    var body: some View {
        ZStack {
            Color.DesignSystem.greyscale900
            if articles.isFeedItemLoaded {
                NavigationStack(path: $path) {
                    ZStack(alignment: .topLeading) {
                        mainContent
                    }
                    .ignoresSafeArea(.all)
                }
            } else {
                VStack(alignment: .center) {
                    Text("loading...")
                        .foregroundColor(Color.DesignSystem.primary100)
                        .font(Font.DesignSystem.bodyLargeBold)
                        .padding([.top, .bottom], 4)
                    LoadingBar()
                }
                .frame(maxWidth: .infinity, maxHeight: 80)
                .background(Color.DesignSystem.greyscale800)
                .cornerRadius(12, corners: .allCorners)
                .padding([.leading, .trailing], 24)
                .padding([.top, .bottom], 12)
            }
        }
        .task {
            articles.getLatestArticles()
        }
        .onReceive(articles.$isFeedItemLoaded) { _ in
            articleFeedItems = articles.list
        }
        .onReceive(categories.$error) { _ in
            AlertToast(
                displayMode: .alert,
                type: .error(Color.DesignSystem.alertsErrorBase),
                title: "Something Broke"
            )
        }
    }

    var mainContent: some View {
        VStack(alignment: .leading) {
            MainHeadingView()
            RecommendationsView(recomendations: categories.list)
            NewsFeed(articleFeedItems: $articleFeedItems)
                .refreshable {
                    articles.getLatestArticles()
                }
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
            case .article(let articleFeedItem):
                ArticleView(path: $path, articleFeedItem: articleFeedItem)
            case .newsList:
                NewsListView(path: $path)
            }
        }
    }

}
