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
            }
        }
        .ignoresSafeArea(.all)
    }
}
