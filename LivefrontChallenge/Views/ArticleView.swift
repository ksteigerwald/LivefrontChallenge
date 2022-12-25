//
//  ArticleView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/23/22.
//

import SwiftUI

struct AIArticle: Hashable {
    let body: String
}

struct ArticleView: View {

    let article: AIArticle

    var body: some View {
        VStack(alignment: .leading) {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: .init(body: "foobar"))
    }
}
