//
//  ContentGenerator.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/27/22.
//

import SwiftUI

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
                    if action != .none {
                        ContentGeneratorRevealView(actionType: $action)
                            .transition(.move(edge: .bottom))
                            .task { await hideContentGeneratorRevealView() }
                            .onTapGesture {
                                withAnimation {
                                    showGeneratorRevealView = false
                                }
                            }
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
                if action == .none {
                    withAnimation {
                        showGeneratorRevealView = false
                    }
                    return
                }
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
            if current == id && isOn {
                isOn = false
                current = .none
                return
            }
            guard current != id && !isOn else {
                isOn = false
                return
            }
            if current == id {
                isOn = true
                return
            }
        }) {
            Circle()
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(
                    Color.DesignSystem.greyscale800
                )
                .overlay(
                    Text(label)
                        .foregroundColor(
                            isOn ? current.onColor : Color.DesignSystem.greyscale500
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
