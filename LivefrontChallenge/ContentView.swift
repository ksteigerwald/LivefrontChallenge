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
            NewsFeed()
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
        .navigationBarHidden(true)
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
