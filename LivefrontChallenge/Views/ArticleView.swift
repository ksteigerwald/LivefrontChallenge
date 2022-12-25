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
    @State private var document: String = ""
    let article: Article
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.category!)
            if isArticleLoaded {
                Text(document)
            } else {
                Text("Our robots are working on summarizing many articles, list articles:")
                ForEach(app.categories.newsForCategory, id: \.self) { article in
                    Text(article)
                }
            }
        }
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
                            await app.articles.generateSummaryArticle(articles: value)
                            guard let doc = app.articles.categorySummary.first else { return }
                            self.document = doc.document ?? "should load but did not"
                            self.isArticleLoaded = true
                        }
                    })
                .store(in: &cancellables)
        }
    }
}
