//
//  Prompts.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/27/22.
//

import Foundation

/// Prompts passed to OpenAI
enum Prompts {
    /// OpenAI Models
    enum Models: String {
        case davinci003 = "text-davinci-003"
    }

    struct PromptModel {
        let data: String

        init(data: String, maxLength: Int = 2000) {
            self.data = data.truncate(maxLength: maxLength)
        }
    }

    case summarizeWithHeadline(context: String)
    case rewordArticle(context: String)
    case summarizeIntoBulletPoints(context: String)
    case sentimentAnalysis(context: String)
    case toneAnalysis(context: String)
    var value: String {
        switch self {
        case .summarizeWithHeadline(let context):
            let content = PromptModel(data: context)
            return "Summeraize these aricles into 5 of paragraphs, include a headline for the summary: \(content.data)"
        case .rewordArticle(let context):
            let content = PromptModel(data: context)
            return "Summarize the following article into 7 of paragraphs, include a headline for the summary: \(content.data)"
        case .summarizeIntoBulletPoints(let context):
            let content = PromptModel(data: context)
            return "Summarize the given content into a list of bullet points: \(content.data)"
        case .sentimentAnalysis(let context):
            return "Provide sentiment analysis for the given content: \(context)"
        case .toneAnalysis(let context):
            return "Identify the tone of the article (positive, negative, neutral) for the given content, respond only with (positive, negative, neutral): \(context)"
        }
    }
}
