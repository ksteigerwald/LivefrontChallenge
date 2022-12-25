//
//  NewsFeed.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import SwiftUI

struct NewsFeed: View {

    @EnvironmentObject var app: AppEnvironment

    var body: some View {
        VStack(alignment: .leading) {
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
                            NewsItem(article: article)
                        }
                    }
                }
            }
        }
    }
}
