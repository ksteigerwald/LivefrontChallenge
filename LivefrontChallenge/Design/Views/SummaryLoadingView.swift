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
    @Binding var categories: [NewsCategory]
    var body: some View {
        ZStack {
            RiveViewModel(fileName: "tech").view()
                .ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Our robots are working on summarizing many articles, list articles:")
                    .foregroundColor(Color.DesignSystem.greyscale50)
                    .padding([.leading, .trailing], 20)
                /// load news article from fetched categories
                ForEach(categories, id: \.self) { category in
                    Text(category.name)
                        .foregroundColor(Color.DesignSystem.secondaryBase)
                }
            }
            .padding(.top, 220)
        }
    }
}
