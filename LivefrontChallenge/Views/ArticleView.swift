//
//  ArticleView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var app: AppEnvironment

    let article: Article
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.category!)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                VStack {
                    Text("Crypto Summary")
                        .font(Font.DesignSystem.headingH3)
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                }
            }
        }
        .task {
            await app.categories.fetchNewsForCategory(category: article.category!)
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: .init(category: "XRP"))
    }
}
