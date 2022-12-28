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
    case original
    case none

    var image: String {
        switch self {
        case .bulletPoints: return "list.bullet"
        case .sentiment: return "gauge.medium"
        case .tone: return "water.waves"
        case .original: return "newspaper"
        case .none: return "x.square.fill"
        }
    }

    var decription: String {
        switch self {
        case .bulletPoints: return "Choose this option to render the given article as a set of bullet points"
        case .sentiment: return "Choose this option to generate AI baseed sentiment analysis"
        case .tone: return "Choose this option to have the AI score the article either Positive, Negative or Neutral"
        case .original: return "Show the original AI generated summary article"
        case .none: return ""
        }
    }

    var loadingMessage: String {
        switch self {
        case .bulletPoints: return "Loading a set of bullet points from the article provided"
        case .sentiment: return "Running sentiment analysis on the given article..."
        case .tone: return "Running tone (positive, negative, neutral) analysis on the given article..."
        case .original: return "Content is being fetched from a given URL, then summarized into 7 paragraphs"
        case .none: return ""
        }
    }

}

/// The ContentGenerator view is a horizontal stack of four ToolButtonViews and a "Generate" button.
struct ContentGenerator: View {

    @Binding var generator: ToolButtonAction
    @State private var action: ToolButtonAction = .none
    @State private var showGeneratorView: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            if showGeneratorView {
                ContentGeneratorRevealView(actionType: action)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .transition(.move(edge: .bottom))
                    .task { await hideContentGeneratorRevealView() }
                    .onTapGesture {
                        showGeneratorView = false
                    }
            }

            HStack {
                ToolButtonView(
                    label: Image(systemName: ToolButtonAction.bulletPoints.image),
                    id: .bulletPoints,
                    current: $action)
                ToolButtonView(
                    label: Image(systemName: ToolButtonAction.sentiment.image),
                    id: .sentiment,
                    current: $action)
                ToolButtonView(
                    label: Image(systemName: ToolButtonAction.tone.image),
                    id: .tone,
                    current: $action)
                ToolButtonView(
                    label: Image(systemName: ToolButtonAction.original.image),
                    id: .original,
                    current: $action)

                Spacer()
                Button(action: {
                    generator = action
                }) {
                    Text("Generate")
                        .padding([.leading, .trailing], 30)
                        .font(Font.DesignSystem.bodyMediumBold)
                        .foregroundColor(Color.DesignSystem.greyscale50)
                }
                .frame(width: 140, height: 40)
                .background(Color.DesignSystem.secondaryBase)
                .clipShape(Capsule())
                .padding([.top, .bottom], 12)
            }
            .background(Color.DesignSystem.greyscale900)
            .frame(maxWidth: .infinity)
        }
        .onChange(of: generator) { setAction in
            action = setAction
        }
        .onChange(of: action) { delievery in
            showGeneratorView = false
            withAnimation {
                showGeneratorView = true
                print("showing details for: \(delievery)")
            }
        }
        .padding(.top, 12)
        .background(Color.DesignSystem.greyscale900)
        .ignoresSafeArea(.all)
    }

    private func hideContentGeneratorRevealView() async {
        try? await Task.sleep(nanoseconds: 7_500_000_000)
        showGeneratorView = false
    }
}

/// A view that represents a button in the app's toolbar. The button consists of a circle with text overlaid on top. The button's state can be changed by binding it to a ToolButtonAction value.
struct ToolButtonView: View {

    let label: Image
    let id: ToolButtonAction
    @Binding var current: ToolButtonAction
    @State private var isOn: Bool = false

    var body: some View {
        Button(action: {
            current = id
            guard $current.wrappedValue != id && !isOn else {
                isOn = false
                return
            }
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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
