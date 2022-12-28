//
//  ArticleView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import SwiftUI

/*
 let loremHead: String = "Headline: Dogecoin Expected to Be a Top Crypto in 2023"
 let lorem: String = "Paragraph 1: According to a recent report from crypto analytics firm Santiment, Dogecoin (DOGE) is expected to be one of the top crypto assets by 2023.\n\nParagraph 2: The report states that DOGE is “one of the few coins that have held a steady spot in the top 10 crypto assets since its launch in 2013.”\n\nParagraph 3: The report also notes that DOGE has seen an increase in search volume from Google and Twitter, with the number of searches increasing by over 200% since the beginning of 2021.\n\nParagraph 4: The report also states that DOGE has seen an increase in its social media presence, with the number of wallet addresses holding DOGE increasing by over 28% since the beginning of 2021.\n\nParagraph 5: The report also notes that DOGE has seen a surge in its trading volume, with the volume increasing by over 200% since the beginning of 2021.\n\nParagraph 6: The report concludes that “it’s likely that Dogecoin will remain a top crypto asset in 2023 and beyond.”\n\nParagraph 7: The report also highlights the potential for DOGE to become a major player in the crypto space, as it has already established itself as a popular asset among investors and traders"

 Article(
 headline: loremHead,
 body: lorem,
 imageURL: "https://placeimg.com/320/240/any"
 )
 */

struct ArticleView: View {
    @EnvironmentObject private var app: AppEnvironment
    @Binding var path: NavigationPath
    let article: NewsArticle
    @State private var generator: ToolButtonAction = .none
    @State private var isLoaded: Bool = false
    @State private var summarizedContent: Article = .init()
    @State private var loadingOrError: String = ToolButtonAction.original.loadingMessage
    @State private var articleCache: Article = .init()

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
                    prompt: .rewordArticle(context: article.url)
                )
                switch result {
                case .success(let article):
                    self.summarizedContent = article
                    self.articleCache = article
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
                    self.displayResults(prompt: .summarizeIntoBulletPoints(context: article.body))
                case .sentiment:
                    self.displayResults(prompt: .sentimentAnalysis(context: article.body))
                case .tone:
                    self.displayResults(prompt: .toneAnalysis(context: article.body))
                case .original:
                    self.summarizedContent = self.articleCache
                    self.isLoaded = true
                default: print(val)
                }
            }
        }
    }

    func displayResults(prompt: Environment.AI.Prompts) {
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
