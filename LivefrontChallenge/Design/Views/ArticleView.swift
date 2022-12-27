//
//  ArticleView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject private var app: AppEnvironment
    @Binding var path: NavigationPath
    let article: NewsArticle
    @State private var generator: ToolButtonAction = .none
    @State private var isLoaded: Bool = false
    @State private var summarizedContent: Article = .init()
    @State private var loadingOrError: String = "Loading content..."

    var body: some View {

        ZStack(alignment: .topLeading) {
            Color.DesignSystem.greyscale900

            if isLoaded {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(summarizedContent.headline)
                            .font(Font.DesignSystem.headingH3)
                            .foregroundColor(Color.DesignSystem.greyscale50)
                            .padding([.top, .bottom], 24)
                        AsyncImage(url: URL(string: article.imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                        } placeholder: {
                            Color.DesignSystem.greyscale50
                        }
                        .frame(maxWidth: .infinity, maxHeight: 180)
                        .cornerRadius(15)
                        .padding(.bottom, 24)

                        Text(summarizedContent.body)
                            .font(Font.DesignSystem.bodyMediumMedium)
                            .foregroundColor(Color.DesignSystem.greyscale50)
                            .lineSpacing(8)
                    }
                }
            } else {
                ScrollView {
                    VStack(alignment: .center) {
                        Text(loadingOrError)
                            .padding(.top, 400)
                    }
                }
            }
        }
        .overlay(
            ContentGenerator(generator: $generator),
            alignment: .bottom)
        .task {
            do {
                let result = await self.app.articles.generateArticleFromSource(
                    prompt: .rewordArticle(context: article.url)
                )
                switch result {
                case .success(let article):
                    self.summarizedContent = article
                    print(summarizedContent.body)
                    self.isLoaded = true
                case .failure(let error):
                    self.loadingOrError = "Something happened \(error)"
                    print("handle error \(error)")
                }
            }
        }
        .modifier(ToolbarModifier(
            path: $path,
            heading: "News Article")
        )
        .navigationBarBackButtonHidden()
        .padding([.leading, .trailing], 20)
        .background(Color.DesignSystem.greyscale900)
        .onChange(of: generator) { val in
            print("top level: \(val)")
        }
    }

}
