//
//  ArticleSummaryView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import SwiftUI
import Combine

class ArticleList: ObservableObject {
    @Published var articles = [Article]()
}

struct ArticleSummaryView: View {

    @EnvironmentObject private var app: AppEnvironment
    @State private var isArticleLoaded = false
    @State private var document: Article = .init()
    @StateObject private var newsSources: ArticleList = .init()
    @Binding var path: NavigationPath
    @State var category: NewsCategory
    @State private var cancellables = [AnyCancellable]()

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
                SummaryLoadingView(newsSources: $newsSources.articles)
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
            // Figure out how to do this in one take vs task, then onRecieve
            app.categories.fetchNewsForCategory(category: category.name)
                .mapError { $0 as Error }
                .map { response in
                    response.articles.map {
                        Article(
                            category: category.name,
                            headline: $0.title,
                            articleURL: $0.url
                        )
                    }
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in}, receiveValue: { articles in
                    self.newsSources.articles = Array(articles.prefix(10))
                })
                .store(in: &cancellables)
        }
        .onReceive(newsSources.$articles) { sources in
            guard !sources.isEmpty else { return }
            let urls: [String] = sources.map { $0.articleURL }
            guard let source = sources.first else { return }
            app.articles.generateSummaryArticle(category: source.category, articles: urls)
                .sink(receiveCompletion: {_ in }, receiveValue: { response in
                    guard let choice = response.choices.first else { return }
                    let article = Article(
                        category: source.category,
                        document: choice.text
                    )
                    self.document = article
                    self.isArticleLoaded = true
                })
                .store(in: &cancellables)

        }
    }
}
