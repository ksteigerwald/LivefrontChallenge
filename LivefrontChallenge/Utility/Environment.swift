//
//  Environment.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/24/22.
//

import Foundation

/// The Environment enum contains all the necessary environment variables and keys for making network requests to the OpenAI and CryptoCompare APIs.
public enum Environment {

    /// The Token enum represents the different keys that are needed to make requests to the APIs. Each token is associated with a string value.
    enum Token: String {
        /// OpenAI Key goes here
        case openai = "123"
        /// CryptoCompare Key goes here
        case cryptoCompare = "a123"
    }

    /// The `Key` enum represents the different types of keys that are used to authenticate network requests.
    enum Key {
        case apikey(key: Token)
        case bearer(key: Token)
        case plain(Token)

        var value: String {
            switch self {
            case .apikey(let token):
                return "Apikey \(token.rawValue)"
            case .bearer(let token):
                return "Bearer \(token.rawValue)"
            case .plain(let token):
                return token.rawValue
            }
        }
    }

    /// Namespace for OpenAI configs
    enum AI {

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

        /// Prompts passed to OpenAI
        enum Prompts {
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
                    let content = PromptModel(data: context)
                    return "Provide sentiment analysis for the given content: \(content.data)"
                case .toneAnalysis(let context):
                    let content = PromptModel(data: context)
                    return "Identify the tone of the article (positive, negative, neutral) for the given content: \(content.data)"
                }
            }
        }
    }
}
