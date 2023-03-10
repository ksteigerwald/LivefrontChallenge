//
//  OpenAITests.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 12/22/22.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import LivefrontChallenge

final class OpenAITests: XCTestCase {
    var service: OpenAIService!
    override func setUpWithError() throws {
        service = OpenAIService()
    }

    func testcompletions() async {
        let params = OpenAIRequestParams(
            model: "text-davinci-003",
            prompt: "Summeraize these articles:\nhttps://www.coindesk.com/business/2022/12/22/ftx-ask-judge-for-help-in-fight-over-robinhood-shares-worth-about-450m/?utm_medium=referral&utm_source=rss&utm_campaign=headlines,\n    \"https://cointelegraph.com/news/the-most-eco-friendly-blockchain-networks-in-2022",
            temperature: 0.5,
            max_tokens: 120,
            top_p: 1,
            frequency_penalty: 0,
            presence_penalty: 0
        )

        stub(condition: isHost("api.openai.com")) { _ in
            let stubPath = OHPathForFile("completion.json", JSONReusable.self)
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }

        let result = try! await service.getSummaries(requestParams: params)

        switch result {
        case .success(let data):
            XCTAssertEqual(data.model, "text-davinci-003")
            XCTAssertEqual(data.id, "cmpl-6QUNMKAMo1CkvCEOYCmY8aD7B1Hba")
            XCTAssertEqual(data.usage.completionTokens, 94)
            XCTAssertEqual(data.usage.promptTokens, 112)
        case .failure(let err):
            print(err)
        }
    }
}
