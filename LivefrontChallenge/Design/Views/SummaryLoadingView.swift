//
//  SwiftUIView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/26/22.
//

import SwiftUI
import RiveRuntime

struct SummaryLoadingView: View {
    @EnvironmentObject var app: AppEnvironment
    @Binding var newsSources: [Article]

    var body: some View {
        ZStack {
            Color.DesignSystem.secondaryBase
            VStack(alignment: .leading) {
                Text("Summarizing Articles")
                    .multilineTextAlignment(.leading)
                    .font(Font.DesignSystem.headingH3)
                    .foregroundColor(Color.DesignSystem.greyscale50)
                    .padding([.leading, .trailing], 20)
                /// load news article from fetched categories
                VStack(alignment: .leading) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(newsSources, id: \.articleURL) { item in
                                Text(item.articleURL)
                                    .font(Font.DesignSystem.bodyXsmallBold)
                                    .foregroundColor(Color.DesignSystem.greyscale900)
                                    .padding([.top, .leading, .trailing], 20)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.DesignSystem.greyscale50)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
                .padding([.leading, .trailing], 24)
            }
            .padding(.top, 220)
        }
        .ignoresSafeArea()
    }
}

struct SummaryLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryLoadingView(newsSources: .constant([
            Article(articleURL: "https://coinedition.com/algorand-algo-exhibits-a-bullish-flag-but-bears-still-loom/"),
            Article(articleURL: "https://dailyhodl.com/2022/12/27/coin-bureau-names-top-altcoins-to-invest-in-during-a-recession/"),
            Article(articleURL: "https://coinedition.com/crypto-youtuber-picks-atom-algo-aave-for-2023-bull-market/"),
            Article(articleURL: "https://thenewscrypto.com/algobharats-exclusive-interview-with-thenewscrypto/"),
            Article(articleURL: "https://ambcrypto.com/algorand-algo-price-prediction-13/"),
            Article(articleURL: "https://coinedition.com/apecoin-ape-surpasses-algorand-in-market-capitalization/"),
            Article(articleURL: "https://www.cryptopolitan.com/bitcoin-ethereum-algorand-and-vechain-daily-price-analyses-20-december-roundup/"),
            Article(articleURL: "https://www.cryptopolitan.com/ark-price-prediction-2022-2031-is-ark-a-good-investment/")
        ]))

    }
}
