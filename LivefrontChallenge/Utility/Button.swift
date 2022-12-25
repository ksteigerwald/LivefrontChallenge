//
//  Button.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(
                configuration.isPressed ?
                Color.DesignSystem.secondaryBase :
                Color.DesignSystem.greyscale50
            )
            .background(
                configuration.isPressed ?
                Color.DesignSystem.greyscale50 :
                Color.DesignSystem.secondaryBase
            )
            .cornerRadius(12.0)
            .padding()
    }
}
