//
//  MainHeadingView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import SwiftUI

struct MainHeadingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("What's intrest you?")
                .foregroundColor(Color.DesignSystem.greyscale50)
                .font(Font.DesignSystem.headingH2)
            Text("Pick a Topic and let AI summarize Today's content")
                .foregroundColor(Color.DesignSystem.greyscale500)
                .font(Font.DesignSystem.bodyLargeRegular)
                .padding(.bottom, 50)
        }
    }
}
