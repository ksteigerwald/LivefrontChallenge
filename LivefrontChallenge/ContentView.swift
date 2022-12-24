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

    let article = AIArticle(body: "XRP")

    var mainContent: some View {
        VStack(alignment: .leading) {
            Text("Recommendations")
                .foregroundColor(Color.DesignSystem.primary100)
                .font(Font.DesignSystem.headingH2)
            HStack {
                LazyHGrid(rows: gridLayout, alignment: .center, spacing: columnSpacing, pinnedViews: []) {
                    HStack {
                        ForEach(app.categories.recommendations, id: \.name) { recomendation in
                            Text(recomendation.name)
                                .font(.body)
                                .fontWeight(.heavy)
                        }
                    }
                }

            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        }
    }
    var body: some View {
        ZStack {
            Color.DesignSystem.greyscale900
            if isCategoriesLoaded {
                mainContent
            } else {
                Text("loading...")
                    .foregroundColor(Color.DesignSystem.primary100)
                    .font(Font.DesignSystem.headingH1)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle("CryptoBytes")
        .font(Font.DesignSystem.headingH1)
        .task {
            do {
                await self.app.categories.fetchCategories()
                self.isCategoriesLoaded = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
