//
//  ContentGenerator.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/27/22.
//

import SwiftUI

/// Enum representing the four types of tool buttons available.
enum ToolButtonAction {
    case bulletPoints
    case sentiment
    case tone
    case marketer
    case none
}

/// The ContentGenerator view is a horizontal stack of four ToolButtonViews and a "Generate" button.
struct ContentGenerator: View {

    @Binding var generator: ToolButtonAction

    var body: some View {
        HStack {
            ToolButtonView(
                label: "Dz",
                id: .bulletPoints,
                current: $generator)
            ToolButtonView(
                label: "Dv",
                id: .sentiment,
                current: $generator)
            ToolButtonView(
                label: "Pm",
                id: .tone,
                current: $generator)
            ToolButtonView(
                label: "Mk",
                id: .marketer,
                current: $generator)

            Spacer()
            Button(action: {}) {
                Text("Generate")
                    .padding([.leading, .trailing], 30)
                    .font(Font.DesignSystem.bodyMediumBold)
                    .foregroundColor(Color.DesignSystem.greyscale50)
            }
            .frame(width: 140, height: 40)
            .background(Color.DesignSystem.secondaryBase)
            .clipShape(Capsule())
        }
        .onChange(of: generator) { newVal in
            generator = newVal
        }
        .padding(.top, 12)
        .background(Color.DesignSystem.greyscale900)
        .ignoresSafeArea(.all)
    }
}

/// A view that represents a button in the app's toolbar. The button consists of a circle with text overlaid on top. The button's state can be changed by binding it to a ToolButtonAction value.
struct ToolButtonView: View {

    let label: String
    let id: ToolButtonAction
    @Binding var current: ToolButtonAction
    @State private var isOn: Bool = false
    var body: some View {
        Button(action: {
            guard $current.wrappedValue != id && !isOn else {
                isOn = false
                return
            }
            current = id
            if $current.wrappedValue == id {
                isOn = true
            }
        }) {
            Circle()
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(
                    $isOn.wrappedValue ? Color.DesignSystem.greyscale50 : Color.DesignSystem.greyscale800
                )
                .overlay(
                    Text(label)
                        .foregroundColor(
                            $isOn.wrappedValue ? Color.DesignSystem.secondaryBase : Color.DesignSystem.greyscale500
                        )
                        .font(Font.DesignSystem.bodySmallBold)
                )
        }
        .onChange(of: current) { _ in
            isOn = current == id
        }
    }
}
