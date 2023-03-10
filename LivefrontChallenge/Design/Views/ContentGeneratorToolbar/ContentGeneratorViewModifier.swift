//
//  ContentGeneratorViewModifier.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/28/22.
//

import SwiftUI

struct ContentGeneratorViewModifier: ViewModifier {

    @Binding var article: Article
    @Binding var generator: ToolButtonAction
    @Binding var isLoaded: Bool
    @Binding private var loadingOrError: String
    @Binding private var summarizedContent: Article
    @Binding private var articleCache: Article

    func body(content: Content) -> some View {
        content
            .onChange(of: generator) { val in
                Task {
                    self.isLoaded = false
                    self.loadingOrError = generator.loadingMessage

                    switch val {
                    case .bulletPoints:
                        self.displayResults(prompt: .summarizeIntoBulletPoints(context: article.body))
                    case .sentiment:
                        self.displayResults(prompt: .sentimentAnalysis(context: article.body))
                    case .tone:
                        self.displayResults(prompt: .toneAnalysis(context: article.body))
                    case .original:
                        self.summarizedContent = self.articleCache
                        self.isLoaded = true
                    default: print(val)
                    }
                }
            }
    }

    func displayResults(prompt: Prompts) {}
}
