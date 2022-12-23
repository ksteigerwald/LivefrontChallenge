//
//  OpenAIModels.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

struct OpenAIRequestParams: Encodable {
    /// The name of the model to use for the request
    let model: String

    /// The prompt to be completed by the model
    let prompt: String

    /// Controls the level of creativity of the model
    /// A value of 0 will generate more conservative completions, while a value of 1 will generate more creative completions
    let temperature: Float

    /// The maximum number of tokens (common sequences of characters) to generate in the completion
    let max_tokens: Int

    /// Controls the proportion of the mass of the distribution given to the top tokens
    let top_p: Float

    /// Controls the importance of maintaining the frequency of each token in the source text
    /// A value of 0 means no penalty, while a value of 1 will penalize completions that deviate significantly from the frequency of the source text
    let frequency_penalty: Float

    /// Controls the importance of maintaining the presence of each token in the source text
    /// A value of 0 means no penalty, while a value of 1 will penalize completions that do not contain all tokens in the source text
    let presence_penalty: Float
}

struct OpenAIResponse: Decodable {
    /// The unique identifier for the response
    let id: String

    /// The type of response object
    let object: String

    /// The timestamp of when the response was created
    let created: Int

    /// The name of the model used to generate the response
    let model: String

    /// An array of completion choices
    let choices: [Choice]

    /// Statistics about the usage of the response
    let usage: Usage
}

struct Choice: Decodable {
    /// The completed text
    let text: String

    /// The index of the choice
    let index: Int

    /// An array of log probabilities for each token in the choice
    let logprobs: [Float]?

    /// The reason why the choice was generated
    let finish_reason: String
}

struct Usage: Decodable {
    /// The number of tokens in the prompt
    let prompt_tokens: Int

    /// The number of tokens in the completion
    let completion_tokens: Int

    /// The total number of tokens in the response
    let total_tokens: Int
}
