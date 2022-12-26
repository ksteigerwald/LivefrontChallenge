//
//  ArticleView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/25/22.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject private var app: AppEnvironment
    @Binding var path: NavigationPath

    let article: NewsArticle

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.DesignSystem.greyscale900
            VStack(alignment: .leading) {
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
            }
        }
        .padding([.leading, .trailing], 20)
        .background(Color.DesignSystem.greyscale900)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                }
            }
        }
    }
}
