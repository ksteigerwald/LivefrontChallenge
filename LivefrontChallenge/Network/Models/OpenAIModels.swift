//
//  OpenAIModels.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation
import BackedCodable

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
    var id: String

    /// The type of response object
    var object: String

    /// The timestamp of when the response was created
    var created: Int

    /// The name of the model used to generate the response
    var model: String

    /// An array of completion choices
    var choices: [Choice]

    /// Statistics about the usage of the response
    var usage: Usage
}

struct Choice: BackedDecodable, Decodable {
    /// Default init for Backed Framework
    init(_: DeferredDecoder) {  }

    /// The completed text
    @Backed()
    var text: String

    /// The index of the choice
    @Backed()
    var index: Int

    /// An array of log probabilities for each token in the choice
    @Backed("logprobs", options: .lossy)
    var logprobs: [Float]?

    /// The reason why the choice was generated
    @Backed("finish_reason")
    var finishReason: String
}

struct Usage: BackedDecodable, Decodable {

    /// Default init for Backed Framework
    init(_: DeferredDecoder) {  }

    /// The number of tokens in the prompt
    @Backed("prompt_tokens")
    var promptTokens: Int

    /// The number of tokens in the completion
    @Backed("completion_tokens")
    var completionTokens: Int

    /// The total number of tokens in the response
    @Backed("total_tokens")
    var totalTokens: Int
}
