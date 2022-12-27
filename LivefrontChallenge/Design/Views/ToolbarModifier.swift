//
//  ToolbarModifier.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/26/22.
//

import SwiftUI

struct ToolbarModifier: ViewModifier {

    @Binding var path: NavigationPath
    let heading: String

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        path.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.DesignSystem.greyscale50)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(heading)
                        .font(Font.DesignSystem.bodyLargeBold)
                        .foregroundColor(Color.DesignSystem.greyscale50)
                }
            }
    }
}
