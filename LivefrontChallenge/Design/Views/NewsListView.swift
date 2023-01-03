//
//  NewsListView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/26/22.
//

import SwiftUI
import RiveRuntime

struct NewsListView: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.DesignSystem.greyscale900
            VStack {
                RiveViewModel(fileName: "tech").view()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                Text("Hello, I never found a home, but I like to hang out here.")
                    .font(Font.DesignSystem.bodyMediumRegular)
            }
            .navigationBarBackButtonHidden()
            .modifier(ToolbarModifier(
                path: $path,
                heading: "Zippy's Play Place")
            )
        }
        .ignoresSafeArea(.all)
    }
}
