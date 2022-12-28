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

    @State private var generator: ToolButtonAction = .none
    @State private var isLoaded: Bool = false
    @State private var summarizedContent: Article = .init()
    @State private var cachedArticle: Article = .init()
    @State private var loadingOrError: String = ToolButtonAction.original.loadingMessage
    let articleFeedItem: ArticleFeedItem
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
                        AsyncImage(url: URL(string: articleFeedItem.imageUrl)) { image in
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
                            .padding(.bottom, 80)
                        Spacer()
                        Spacer()

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
                    prompt: .rewordArticle(context: articleFeedItem.url)
                )
                switch result {
                case .success(let article):
                    self.cachedArticle = article
                    self.summarizedContent = article
                    self.isLoaded = true
                case .failure(let error):
                    self.loadingOrError = "Something happened \(error)"
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
            Task {
                self.isLoaded = false
                self.loadingOrError = generator.loadingMessage

                switch val {
                case .bulletPoints:
                    self.displayResults(prompt: .summarizeIntoBulletPoints(context: articleFeedItem.body))
                case .sentiment:
                    self.displayResults(prompt: .sentimentAnalysis(context: articleFeedItem.body))
                case .tone:
                    self.displayResults(prompt: .toneAnalysis(context: articleFeedItem.body))
                case .original:
                    self.summarizedContent = self.cachedArticle
                    self.isLoaded = true
                default: print(val)
                }
            }
        }
    }

    func displayResults(prompt: Prompts) {
        Task {
            do {
                let result = await self.app.articles.generateArticleFromSource(
                    prompt: prompt
                )
                switch result {
                case .success(let article):
                    self.summarizedContent = article
                    self.isLoaded = true
                case .failure(let error):
                    self.loadingOrError = "Something happened \(error)"
                }
            }
        }
    }
}
