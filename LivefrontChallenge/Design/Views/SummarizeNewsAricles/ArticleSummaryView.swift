//
//  ArticleSummaryView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import SwiftUI
import Combine

struct ArticleSummaryView: View {

    @EnvironmentObject private var app: AppEnvironment
    @State private var isArticleLoaded = false
    @CategoryProperty var categories: Categories
    @ArticleProperty var articles: Articles

    @State private var feeds: [Article] = []

    @Binding var path: NavigationPath
    @State var category: NewsCategory
    @State private var cancellables = [AnyCancellable]()

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

                        AsyncImage(url: URL(string: "https://placeimg.com/320/240/any")) { image in
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
                    .environmentObject(AppEnvironment())
            }
            Spacer()
        }
        .background(Color.DesignSystem.greyscale900)
        .navigationBarBackButtonHidden()

        .modifier(ToolbarModifier(
            path: $path,
            heading: "Summary Article")
        )
        .task {
            categories.getNewsFromCategory(category: category)
        }
        .onReceive(categories.$news) { news in
            feeds = news
            articles.generateSummaryArticle(category: category, articles: news)
        }
    }
}
