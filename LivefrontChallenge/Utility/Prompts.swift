//
//  Prompts.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/27/22.
//

import Foundation

/// Prompts passed to OpenAI representing different prompts for text analysis
public enum Prompts {
    /// OpenAI Models
    enum Models: String {
        case davinci003 = "text-davinci-003"
    }

    /// Takes in content to ensure we avoid hitting max token limit on OpenAI
    struct PromptModel {
        let data: String

        init(data: String, maxLength: Int = 2000) {
            self.data = data.truncate(maxLength: maxLength)
        }
    }
    /// summarizeWithHeadline: Summarize articles into 5 paragraphs and include a headline for the summary
    case summarizeWithHeadline(context: String)
    /// rewordArticle: Rewrite an article in your own words and summarize it into 7 paragraphs
    case rewordArticle(context: String)
    /// summarizeIntoBulletPoints: Summarize the given content into a list of bullet points
    case summarizeIntoBulletPoints(context: String)
    /// sentimentAnalysis: Provide sentiment analysis for the given content
    case sentimentAnalysis(context: String)
    /// toneAnalysis: Identify the tone of the article (positive, negative, neutral) for the given
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
            return "Summarize the given content into a list of bullet points, include a headline for the list: \(content.data)"
        case .sentimentAnalysis(let context):
            return "Provide sentiment analysis for the given content, include a headline for the analysis: \(context)"
        case .toneAnalysis(let context):
            return "Identify the tone of the article (positive, negative, neutral) for the given content, respond only with (positive, negative, neutral): \(context)"
        }
    }
}
