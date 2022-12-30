//
//  ArticleLoadingView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/30/22.
//

import SwiftUI

struct ArticleLoadingView: View {

    @Binding var loadingOrError: ToolButtonAction

    var body: some View {
        ZStack {
            Color.DesignSystem.greyscale900
            VStack {
                HStack {
                    Circle()
                        .frame(width: 48, height: 48, alignment: .center)
                        .foregroundColor(
                            Color.DesignSystem.greyscale900
                        )
                        .overlay(
                            Image(systemName: "doc.text")
                                .frame(maxWidth: 30)
                                .foregroundColor(
                                    Color.DesignSystem.othersCamaron
                                )
                                .font(Font.DesignSystem.bodySmallBold)
                        ).padding(.trailing, 12)

                    VStack(alignment: .leading) {
                        Text(loadingOrError.loadingHeading)
                            .foregroundColor(Color.DesignSystem.greyscale50)
                            .font(Font.DesignSystem.bodySmallBold)
                            .padding(.bottom, 4)
                        Text(loadingOrError.loadingMessage)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.DesignSystem.greyscale500)
                            .font(Font.DesignSystem.bodyXsmallMedium)

                    }
                }
                .padding(.all, 16)
            }
            .background(Color.DesignSystem.greyscale800)
            .frame(maxWidth: .infinity)
            .cornerRadius(20, corners: .allCorners)
        }
        .background(Color.DesignSystem.greyscale900)
        .ignoresSafeArea(.all)
    }
}

struct ArticleLoadingView_Previews: PreviewProvider {

    static var previews: some View {
        ArticleLoadingView(loadingOrError: .constant(ToolButtonAction.original) )
    }
}
