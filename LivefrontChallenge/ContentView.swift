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
    var body: some View {
        VStack(alignment: .leading) {
            if isCategoriesLoaded {
                Text("Recommendations")
                    .font(.system(.body, weight: .bold))
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
            List(app.categories.categories, id: \.name) { _ in
                NavigationLink(article.body, value: Route.detail(article))
                    .font(.body)
                    .foregroundColor(.blue)

            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            } else {
                Text("loading...")
            }

        }
        .navigationTitle("CryptoBytes")
        .padding()
        .task {
            do {
                try! await self.app.categories.fetchCategories()
                self.isCategoriesLoaded = true
            }
            catch {
                print("error...")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
