//
//  ArticleSummaryView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import SwiftUI
import Combine

struct ArticleSummaryView: View {

    @EnvironmentObject var app: AppEnvironment
    @State private var cancellables = [AnyCancellable]()
    @State private var isArticleLoaded = false
    @State private var document: Article = Article()
    @Binding var path: NavigationPath

    @State private var tempCategories: [NewsCategory] = [NewsCategory(name: "XRP")]

    let article: Article
    var body: some View {
        ZStack(alignment: .leading) {
            Color.DesignSystem.greyscale900
            if isArticleLoaded {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(document.headline)
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

                        Text(document.body)
                            .font(.body)
                            .lineSpacing(8)
                            .foregroundColor(Color.DesignSystem.greyscale50)
                        Spacer()
                    }
                    .padding([.leading, .trailing], 20)

                }
            } else {
                SummaryLoadingView(categories: $tempCategories )
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
            app.categories.fetchNewsForCategory(category: article.category)
                .mapError { $0 as Error }
                .flatMap { response in
                    app.articles.generateSummaryArticle(
                        category: article.category,
                        articles: response.articles.map { $0.url }
                    )
                }
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { response in
                        guard let choice = response.choices.first else {
                            return
                        }

                        let article = Article(
                            category: "XRP",
                            document: choice.text
                        )
                        self.document = article
                        self.isArticleLoaded = true
                    })
                .store(in: &cancellables)
        }
    }
}
