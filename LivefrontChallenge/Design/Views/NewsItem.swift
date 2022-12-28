//
//  NewsItem.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import SwiftUI

struct NewsItem: View {

    let articleFeedItem: ArticleFeedItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(articleFeedItem.categories)
                    .font(Font.DesignSystem.bodySmallMedium)
                    .foregroundColor(Color.DesignSystem.greyscale500)
                Text(articleFeedItem.title)
                    .font(Font.DesignSystem.headingH6)
                    .foregroundColor(Color.DesignSystem.greyscale50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            AsyncImage(url: URL(string: articleFeedItem.imageUrl)) { image in
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
