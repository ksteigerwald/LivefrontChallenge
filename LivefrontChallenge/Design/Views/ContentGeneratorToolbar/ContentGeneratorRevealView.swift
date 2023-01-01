//
//  ContentGeneratorRevealView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/27/22.
//

import SwiftUI

struct ContentGeneratorRevealView: View {
    @Binding var actionType: ToolButtonAction
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .frame(width: 48, height: 48, alignment: .center)
                    .foregroundColor(
                        Color.DesignSystem.greyscale900
                    )
                    .overlay(
                        Image(systemName: actionType.image)
                            .foregroundColor(
                                actionType.onColor
                            )
                            .font(Font.DesignSystem.bodySmallBold)
                    )

                VStack(alignment: .leading) {
                    Text(actionType.loadingHeading)
                        .fixedSize()
                        .foregroundColor(Color.DesignSystem.greyscale50)
                        .font(Font.DesignSystem.bodySmallBold)
                        .padding(.bottom, 4)
                    Text(actionType.decription)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color.DesignSystem.greyscale500)
                        .font(Font.DesignSystem.bodyXsmallMedium)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.all, 16)
            Spacer()
                .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: 140, alignment: .top)
        .background(Color.DesignSystem.greyscale800)
        .cornerRadius(12, corners: [.topLeft, .topRight])
    }
}

struct ContentGeneratorRevealView_Previews: PreviewProvider {

    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.DesignSystem.greyscale900
            Spacer()
            ContentGeneratorRevealView(
                actionType: .constant(ToolButtonAction.bulletPoints)
            )
        }
        .ignoresSafeArea(.all)
    }
}

struct CaptionText: View {
    let content: String

    var body: some View {
        Text(content)
            .multilineTextAlignment(.center)
            .font(Font.DesignSystem.bodyMediumMedium)
            .foregroundColor(Color.DesignSystem.greyscale900)
    }
}
