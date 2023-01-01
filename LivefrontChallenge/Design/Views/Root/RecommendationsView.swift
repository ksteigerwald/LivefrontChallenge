//
//  RecommendationsView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import SwiftUI

struct RecommendationsView: View {
    var recomendations: [NewsCategory]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommendations")
                .foregroundColor(Color.DesignSystem.greyscale50)
                .font(Font.DesignSystem.bodyLargeBold)
                .padding(.bottom, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(
                    rows: [GridItem(.flexible(minimum: 64))],
                    alignment: .top,
                    spacing: 0,
                    pinnedViews: []) {
                        ForEach(recomendations, id: \.name) { recomendation in
                            Button(action: {}) {
                                NavigationLink(recomendation.name, value: Route.summaryView(recomendation))
                                    .font(Font.DesignSystem.bodySmallBold)
                                    .frame(width: 64, height: 24)
                                    .padding(0)
                            }
                            .padding(0)
                            .buttonStyle(SecondaryButtonStyle())
                        }
                }
            }
            .frame(height: 60)
            .padding(.bottom, 24)
        }
    }
}
