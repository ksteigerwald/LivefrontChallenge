//
//  LoadingBar.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 1/2/23.
//

import SwiftUI

struct LoadingBar: View {
    @State private var progress: CGFloat = 0.0
    @State public var container: CGFloat = 300
    @State public var loadingColor: Color = Color.DesignSystem.secondaryBase
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: container, height: 10)
                .foregroundColor(Color.DesignSystem.greyscale800)
            Capsule()
                .frame(width: progress, height: 10)
                .foregroundColor(loadingColor)
        }
        .onAppear {
            withAnimation(.linear) {
                startLoading()
            }
        }
    }

    func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.progress += 1
            if self.progress >= container {
                timer.invalidate()
            }
        }
    }
}

struct LoadingBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.DesignSystem.greyscale900
            LoadingBar()
        }
        .ignoresSafeArea()
    }
}
