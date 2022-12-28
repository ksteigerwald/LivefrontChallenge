//
//  RecommendationsView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject var app: AppEnvironment

    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommendations")
                .foregroundColor(Color.DesignSystem.greyscale50)
                .font(Font.DesignSystem.bodyLargeBold)
                .padding(0)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(
                    rows: [GridItem(.flexible(minimum: 64))],
                    alignment: .top,
                    spacing: 0,
                    pinnedViews: []) {
                        ForEach(app.categories.recommendations, id: \.name) { recomendation in
                            Button(action: {
                            }
                            ) {
                                NavigationLink(recomendation.name, value: Route.detail(recomendation.name))
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
        }
    }
}
