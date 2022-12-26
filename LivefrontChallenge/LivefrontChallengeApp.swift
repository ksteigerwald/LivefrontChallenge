//
//  LivefrontChallengeApp.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import SwiftUI
import DesignSystem

@main
struct LivefrontChallengeApp: App {

    @EnvironmentObject var app: AppEnvironment

    var body: some Scene {
        WindowGroup {
            // When testing do not run the whole app in order to speed up things
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                EmptyView()
            } else {
                ZStack {
                    Color.DesignSystem.greyscale900
                    RootView()
                        .environmentObject(AppEnvironment())
                }
                .ignoresSafeArea(.all)


            }
        }
    }
}
