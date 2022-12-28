//
//  ContentGeneratorRevealView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/27/22.
//

import SwiftUI

struct ContentGeneratorRevealView: View {
    let actionType: ToolButtonAction
    var body: some View {
        VStack(alignment: .center) {
            Circle()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundColor(Color.DesignSystem.secondaryBase)
                .overlay(
                    Image(systemName: actionType.image)
                        .foregroundColor(Color.DesignSystem.greyscale50)
                )
                .padding([.top], 12)
            switch actionType {
            case .bulletPoints:
                Text("Choose this option to render the given article as a set of bullet points")
                    .multilineTextAlignment(.center)
                    .font(Font.DesignSystem.bodyMediumMedium)
                    .foregroundColor(Color.DesignSystem.greyscale900)
                    .padding([.leading, .trailing], 48)
            default:
                Text("default...")
            }
            Spacer()
        }
        .background(Color.DesignSystem.greyscale50)
        .opacity(0.9)
    }
}

struct ContentGeneratorRevealView_Previews: PreviewProvider {
    static var previews: some View {
        ContentGeneratorRevealView(actionType: .bulletPoints)
    }
}
