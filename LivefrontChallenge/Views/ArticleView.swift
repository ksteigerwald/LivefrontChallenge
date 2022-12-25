//
//  ArticleView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import SwiftUI
import Combine

struct ArticleView: View {
    @EnvironmentObject var app: AppEnvironment
    @State private var cancellables = [AnyCancellable]()
    @State private var isArticleLoaded = false
    @State private var document: Article = Article()
    let article: Article
    var body: some View {
        ZStack(alignment: .leading) {
            Color.DesignSystem.greyscale900
            if isArticleLoaded {
                VStack(alignment: .leading) {
                    Text(document.headline ?? "no headline....")
                        .font(.headline)
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                        .padding(.bottom, 20)
                    Text(document.body ?? "no body....")
                        .font(.body)
                        .foregroundColor(Color.DesignSystem.greyscale50)
                    Spacer()
                }
            } else {
                VStack(alignment: .leading) {
                    Text(article.category!)
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                    Text("Our robots are working on summarizing many articles, list articles:")
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                    ForEach(app.categories.newsForCategory, id: \.self) { article in
                        Text(article)
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                    }
                }
            }
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .background(Color.DesignSystem.greyscale900)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                VStack {
                    Text("Crypto Summary")
                        .font(Font.DesignSystem.headingH3)
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                }
            }
        }
        .task {
            _ = await app.categories.fetchNewsForCategory(category: article.category!)
            app.categories.$newsForCategory
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { value in
                        Task {
                            await app.articles.generateSummaryArticle(
                                category: article.category!,
                                articles: value
                            )
                            guard let doc = app.articles.categorySummary.first else { return }
                            self.document = doc
                            self.isArticleLoaded = true
                        }
                    })
                .store(in: &cancellables)
        }
    }
}
