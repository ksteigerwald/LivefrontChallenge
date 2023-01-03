//
//  ArticleSummaryView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import SwiftUI
import Combine
import AlertToast

struct ArticleSummaryView: View {

    @CategoryProperty var categories: Categories
    @ArticleProperty var articles: Articles

    @State private var feeds: [Article] = []
    @Binding var path: NavigationPath
    @State var category: NewsCategory

    @State private var hasError: Bool = false
    @State private var errorMsg: String = ""

    var body: some View {
        ZStack(alignment: .leading) {
            Color.DesignSystem.greyscale900
            if articles.generatedSummaryLoaded {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(articles.document.headline)
                            .lineLimit(3)
                            .font(Font.DesignSystem.headingH3)
                            .foregroundColor(Color.DesignSystem.greyscale50)
                            .padding([.top, .bottom], 24)

                        AsyncImage(url: URL(string: articles.document.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 327, maxHeight: 180)
                                .cornerRadius(20)
                                .padding(.bottom, 24)

                        } placeholder: {
                            Color.DesignSystem.greyscale50
                        }

                        Text(articles.document.body)
                            .font(.body)
                            .lineSpacing(8)
                            .foregroundColor(Color.DesignSystem.greyscale50)
                        Spacer()
                    }
                    .padding([.leading, .trailing], 20)

                }
            } else {
                SummaryLoadingView(newsSources: $feeds)
            }
            Spacer()
        }
        .background(Color.DesignSystem.greyscale900)
        .navigationBarBackButtonHidden()
        .modifier(ToolbarModifier(
            path: $path,
            heading: "Summary Article")
        )
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
        .onReceive(articles.$error) { error in
            guard let msg = error else { return }
            errorMsg = msg.localizedDescription
            hasError = true
        }
        .task {
            // Establish a baseline state
            articles.generatedSummaryLoaded = false
            articles.document = .init()
            categories.getNewsFromCategory(category: category)
        }
        .onReceive(categories.$news) { news in
            guard !news.isEmpty else { return }
            feeds = news
            articles.generateSummaryArticle(category: category, articles: news)
        }
        .onDisappear {
            // After we load the generated article, clear the feeds to ensure only one completion request is made.
            // TODO: Investigate the feasibility of utilizing property wrappers to facilitate the management of this task.
            // TODO: State between ArticleFeed > Article & Summary is to mixed, sperate.
            feeds = []
            categories.news = []
            articles.list = []
            articles.cached = nil
            articles.firstLoad = false
            articles.isLoaded = false
        }
        .onReceive(articles.$generatedSummaryLoaded) { _ in
            feeds = []
            categories.news = []
            articles.list = []
        }
    }
}
