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
    case tokenError
    case error

    var image: String {
        switch self {
        case .bulletPoints: return "list.bullet"
        case .sentiment: return "gauge.medium"
        case .tone: return "water.waves"
        case .original: return "newspaper"
        case .none: return "x.square.fill"
        case .tokenError: return "exclamationmark.bubble.fill"
        case .error: return "exclamationmark.triangle"
        }
    }

    var decription: String {
        switch self {
        case .bulletPoints: return "Choose this option to render the given article as a set of bullet points"
        case .sentiment: return "Choose this option to generate AI baseed sentiment analysis"
        case .tone: return "Choose this option to have the AI score the article either Positive, Negative or Neutral"
        case .original: return "Show the original AI generated summary article"
        case .none: return ""
        case .tokenError: return "A Token Error has occured"
        case .error: return "An Error has occured"
        }
    }

    var loadingMessage: String {
        switch self {
        case .bulletPoints: return "Loading a set of bullet points from the article provided"
        case .sentiment: return "Running sentiment analysis on the given article..."
        case .tone: return "Running tone (positive, negative, neutral) analysis on the given article..."
        case .original: return "Content is being fetched from a given URL, then summarized into 7 paragraphs"
        case .none: return "Loading"
        case .tokenError: return "We have encounted a generator error, tokens exced limit. Try to regenerate article"
        case .error: return "We are sorry but an error has occured"
        }
    }

    var loadingHeading: String {
        switch self {
        case .bulletPoints: return "Loading Bullet Points"
        case .sentiment: return "Running Sentiment Analysis"
        case .tone: return "Loading Tone Analysis"
        case .original: return "Loading Summarized Article"
        case .none: return "Content is Loading"
        case .tokenError: return "Token Limit Exceded"
        case .error: return "Error"
        }
    }
}

/// The ContentGenerator view is a horizontal stack of four ToolButtonViews and a "Generate" button.
struct ContentGenerator: View {

    @Binding var generator: ToolButtonAction
    @Binding var isParentLoaded: Bool
    @State private var action: ToolButtonAction = .none
    @State private var showGeneratorRevealView: Bool = false

    var body: some View {
        if isParentLoaded {
            ZStack(alignment: .bottomTrailing) {

                if showGeneratorRevealView {
                    ContentGeneratorRevealView(actionType: action)
                        .transition(.move(edge: .bottom))
                        .task { await hideContentGeneratorRevealView() }
                        .onTapGesture {
                            showGeneratorRevealView = false
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
            }
            .onChange(of: generator) { setAction in
                action = setAction
            }
            .onChange(of: action) { _ in
                showGeneratorRevealView = false
                withAnimation {
                    showGeneratorRevealView = true
                }
            }
        } else {
            EmptyView()
        }
    }

    private func hideContentGeneratorRevealView() async {
        try? await Task.sleep(nanoseconds: 7_500_000_000)
        showGeneratorRevealView = false
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


struct CContentGenerator_Previews: PreviewProvider {

    static var previews: some View {
        ZStack(alignment: .bottomLeading) {
            Color.DesignSystem.greyscale900
            ContentGenerator(generator: .constant(.bulletPoints), isParentLoaded: .constant(true))
                .padding([.leading, .trailing], 24)
                .padding(.bottom, 16)
        }
        .ignoresSafeArea()
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
