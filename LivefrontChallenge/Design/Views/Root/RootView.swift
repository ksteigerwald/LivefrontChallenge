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

    // The property wrappers end up becoming ViewModels. I am still
    // groking this technique but will continue to press to find a
    // solution that is more adaptable to SwiftUI best practices.
    @CategoryProperty var categories: Categories
    @FeedProperty var feed: Feed

    @State private var hasError: Bool = false
    @State private var errorMsg: String = ""

    var body: some View {
        ZStack {
            Color.DesignSystem.greyscale900
            if feed.isFeedItemLoaded {
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
            feed.getLatestArticles()
        }
        .onReceive(feed.$isFeedItemLoaded) { _ in
            articleFeedItems = feed.list
        }
        .toast(isPresenting: $hasError, alert: {
            AlertToast(
                displayMode: .alert,
                type: .error(Color.DesignSystem.alertsErrorBase),
                title: "Error: \(errorMsg)"
            )
        }, completion: {
            hasError = false
            errorMsg = ""
        })
        .onReceive(categories.$error) { error in
            guard let msg = error else { return }
            errorMsg = msg.localizedDescription
            hasError = true
        }
    }

    var mainContent: some View {
        VStack(alignment: .leading) {
            MainHeadingView()
            RecommendationsView(recomendations: categories.list)
            NewsFeed(articleFeedItems: $articleFeedItems)
                .refreshable {
                    feed.getLatestArticles()
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
