//
//  LoadingBar.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 1/2/23.
//

import SwiftUI

struct LoadingBar: View {
    @State private var progress: CGFloat = 0.0

    var body: some View {
        ZStack {
            Capsule()
                .frame(width: 300, height: 10)
                .foregroundColor(Color.DesignSystem.greyscale800)
            Capsule()
                .frame(width: progress, height: 10)
                .foregroundColor(Color.DesignSystem.secondaryBase)
        }
        .onAppear {
            withAnimation(.linear) {
                startLoading()
            }
        }
    }

    func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.progress += 10
            if self.progress >= 300 {
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
