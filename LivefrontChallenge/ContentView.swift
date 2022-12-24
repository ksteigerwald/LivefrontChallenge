//
//  ContentView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var repository = CryptoCompareRepository()

    let article = AIArticle(body: "XRP")
    var body: some View {
        VStack {
            List(repository.categories, id: \.categoryName) { _ in
                NavigationLink(article.body, value: Route.detail(article))
                    .font(.body)
                    .foregroundColor(.blue)

            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        }
        .onAppear {
            Task {
                await self.repository.fetchCategories()
            }
        }
        .navigationTitle("Hello World")
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
