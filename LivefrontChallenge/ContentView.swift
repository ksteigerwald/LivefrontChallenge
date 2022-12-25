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
            Section {
                Text("What's intrest you?")
                    .foregroundColor(Color.DesignSystem.greyscale50)
                    .font(Font.DesignSystem.headingH2)
                Text("Pick a Topic and let AI summarize Today's content")
                    .foregroundColor(Color.DesignSystem.greyscale500)
                    .font(Font.DesignSystem.bodyLargeRegular)
                    .padding(.bottom, 50)
            }
            Section {
                VStack(alignment: .leading) {
                    Text("Recommendations")
                        .foregroundColor(Color.DesignSystem.greyscale50)
                        .font(Font.DesignSystem.bodyLargeBold)
                        .padding(0)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(
                            rows: [GridItem(.flexible())],
                            alignment: .top,
                            spacing: 1,
                            pinnedViews: []) {
                            ForEach(app.categories.recommendations, id: \.name) { recomendation in
                                Button(action: {
                                   
                                }) {
                                NavigationLink(recomendation.name, value: Route.detail(article))
                                        .font(Font.DesignSystem.bodySmallBold)
                                        .frame(width: 64, height: 24)
                                }
                                .padding(0)
                                .buttonStyle(SecondaryButtonStyle())
                            }
                        }
                    }
                }
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
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
                self.isCategoriesLoaded = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
