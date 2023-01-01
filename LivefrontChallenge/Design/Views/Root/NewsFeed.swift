//
//  NewsFeed.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import SwiftUI

struct NewsFeed: View {

    @Binding var articleFeedItems: [ArticleFeedItem]

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                HStack {
                    Text("Latest")
                        .font(Font.DesignSystem.bodyLargeBold)
                        .foregroundColor(Color.DesignSystem.greyscale50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    NavigationLink("View More", value: Route.newsList)
                        .font(Font.DesignSystem.bodyMediumMedium)
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            Section {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(articleFeedItems, id: \.hashValue) { article in
                            NavigationLink(value: Route.article(article)) {
                                NewsItem(articleFeedItem: article)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
            }
        }
    }

}
