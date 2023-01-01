//
//  ArticleView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import SwiftUI
import Combine

struct ArticleView: View {
    @Binding var path: NavigationPath

    @State private var cancellables = [AnyCancellable]()
    @State private var generator: ToolButtonAction = .original
    @State private var zStackAlignment: Alignment = .center
    @State public var isLoaded: Bool = false

    @State public var reset: Bool = true

    let articleFeedItem: ArticleFeedItem

    @ArticleProperty var articles: Articles

    var body: some View {
        ZStack(alignment: zStackAlignment) {
            Color.DesignSystem.greyscale900
            if isLoaded {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(articles.generatedContent.headline)
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

                        Text(articles.generatedContent.body)
                            .font(Font.DesignSystem.bodyMediumMedium)
                            .foregroundColor(Color.DesignSystem.greyscale50)
                            .lineSpacing(8)
                            .padding(.bottom, 80)
                    }
                }
            } else {
                ArticleLoadingView(loadingOrError: $generator)
                    .frame(maxWidth: .infinity)
            }
        }
        .overlay(
            ContentGenerator(generator: $generator, isParentLoaded: $isLoaded),
            alignment: .bottom)
        .onDisappear {
            articles.cached = nil
            articles.firstLoad = false
            articles.isLoaded = false
        }
        .task {
            articles.generateArticleFromPrompt(prompt: .rewordArticle(context: articleFeedItem.url))
        }
        .onReceive(articles.$isLoaded) { loaded in
            guard loaded else { return }
            articles.cacheHadler(item: articleFeedItem)
            isLoaded = loaded
            self.zStackAlignment = .topLeading
        }
        .modifier(ToolbarModifier(
            path: $path,
            heading: "News Article")
        )
        .navigationBarBackButtonHidden()
        .padding([.leading, .trailing], 20)
        .background(Color.DesignSystem.greyscale900)
        .onChange(of: generator) { val in
            self.isLoaded = false
            self.zStackAlignment = .center
            switch val {
            case .bulletPoints:
                articles.generateArticleFromPrompt(prompt: .summarizeIntoBulletPoints(context: articleFeedItem.url))
            case .sentiment:
                articles.generateArticleFromPrompt(prompt: .sentimentAnalysis(context: articleFeedItem.url))
            case .tone:
                articles.generateArticleFromPrompt(prompt: .toneAnalysis(context: articleFeedItem.url))
            case .original:
                guard let article = articles.cached else { return }
                articles.generatedContent = article
                self.isLoaded = true
                self.zStackAlignment = .topLeading
            default: print(val)
            }
        }
    }

    func handleTokenError() {
        self.generator = ToolButtonAction.tokenError
        self.zStackAlignment = .center
        // Show the error for 5 seconds, then reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.generator = .original
            self.isLoaded = true
        }
    }
}
