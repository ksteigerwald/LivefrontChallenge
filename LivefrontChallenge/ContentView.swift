//
//  ContentView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var app: AppEnvironment
    @State private var isCategoriesLoaded = false

    var mainContent: some View {
        VStack(alignment: .leading) {
            MainHeadingView()
            RecommendationsView()

            Section {
                HStack {
                    Text("Latest")
                        .font(Font.DesignSystem.bodyLargeBold)
                        .foregroundColor(Color.DesignSystem.greyscale50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    NavigationLink("View More", destination: self)
                        .font(Font.DesignSystem.bodyMediumMedium)
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            Section {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(app.articles.news, id: \.id) { article in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(article.categories)
                                        .font(Font.DesignSystem.bodySmallMedium)
                                        .foregroundColor(Color.DesignSystem.greyscale500)
                                    Text(article.title)
                                        .font(Font.DesignSystem.headingH6)
                                        .foregroundColor(Color.DesignSystem.greyscale50)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(2)
                                }
                                AsyncImage(url: URL(string: article.imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                } placeholder: {
                                    Color.DesignSystem.greyscale50
                                }
                                .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding([.leading, .trailing], 20)
        .padding(.top, 100)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.DesignSystem.greyscale900
            if isCategoriesLoaded {
                mainContent
                Spacer()
            } else {
                Text("loading...")
                    .foregroundColor(Color.DesignSystem.primary100)
                    .font(Font.DesignSystem.headingH1)
            }
        }
        .background(Color.DesignSystem.greyscale900)
        .task {
            do {
                await self.app.categories.fetchCategories()
                await self.app.articles.getLatestArticles()
                self.isCategoriesLoaded = true
            }
        }
    }
}
