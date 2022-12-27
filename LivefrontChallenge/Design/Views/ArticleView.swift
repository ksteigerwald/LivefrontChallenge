//
//  ArticleView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import SwiftUI
let longParagraph = """
Cryptocurrency is a digital or virtual currency that uses cryptography for security and is not backed by any central authority, such as a government or financial institution. The decentralized nature of cryptocurrency means that it is not controlled by any one person or organization, making it resistant to censorship and fraud.

One of the most well-known cryptocurrencies is Bitcoin, which was created in 2009. However, there are now thousands of different cryptocurrencies, each with their own unique features and uses. Cryptocurrencies are often used as a means of exchange, similar to traditional currencies. However, they can also be used for a variety of other purposes, such as storing value or representing ownership of an asset.

Cryptocurrencies are created through a process called mining, in which powerful computers solve complex mathematical problems in order to validate transactions and add them to the blockchain, a public ledger of all transactions. As a reward for their work, miners are awarded with a certain amount of the cryptocurrency.

The value of cryptocurrency is determined by supply and demand on exchanges, similar to traditional currencies. The value of many cryptocurrencies, including Bitcoin, has fluctuated significantly over time, making them a potentially risky investment. However, some people believe that cryptocurrencies have the potential to disrupt traditional financial systems and offer benefits such as lower fees, faster transaction times, and increased security.

Overall, cryptocurrency is a complex and rapidly evolving field that has the potential to change the way we think about money and financial systems. It is important to do thorough research and carefully consider the risks before investing in or using cryptocurrency.
"""


struct ArticleView: View {
    @EnvironmentObject private var app: AppEnvironment
    @Binding var path: NavigationPath

    let article: NewsArticle

    var body: some View {

        ZStack(alignment: .topLeading) {
            Color.DesignSystem.greyscale900
            ScrollView {
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(Font.DesignSystem.headingH3)
                        .foregroundColor(Color.DesignSystem.greyscale50)
                        .padding([.top, .bottom], 24)
                    AsyncImage(url: URL(string: article.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    } placeholder: {
                        Color.DesignSystem.greyscale50
                    }
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .cornerRadius(15)
                    .padding(.bottom, 24)

                    Text(longParagraph)
                        .font(Font.DesignSystem.bodyMediumMedium)
                        .foregroundColor(Color.DesignSystem.greyscale50)
                        .lineSpacing(8)
                }
            }
            .overlay(
                ContentGenerator(),
                alignment: .bottom)
        }
        .modifier(ToolbarModifier(
            path: $path,
            heading: "News Article")
        )
        .navigationBarBackButtonHidden()
        .padding([.leading, .trailing], 20)
        .background(Color.DesignSystem.greyscale900)
    }

}

