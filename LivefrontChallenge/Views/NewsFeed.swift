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
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(article.categories)
                                        .font(Font.DesignSystem.bodySmallMedium)
                                        .foregroundColor(Color.DesignSystem.greyscale500)
                                    Text(article.title)
                                        .font(Font.DesignSystem.headingH6)
                                        .foregroundColor(Color.DesignSystem.greyscale50)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(2)
                                }
                                AsyncImage(url: URL(string: article.imageUrl)) { image in
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
                }
            }
        }
    }
}
