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
                    rows: [GridItem(.flexible())],
                    alignment: .top,
                    spacing: 1,
                    pinnedViews: []) {
                    ForEach(app.categories.recommendations, id: \.name) { recomendation in
                        Button(action: {

                        }) {
                        let article = Article(category: recomendation.name)
                            NavigationLink(recomendation.name, value: Route.detail(recomendation.name))
                                .font(Font.DesignSystem.bodySmallBold)
                                .frame(width: 64, height: 24)
                        }
                        .padding(0)
                        .buttonStyle(SecondaryButtonStyle())
                    }
                }
            }
        }
    }
}
