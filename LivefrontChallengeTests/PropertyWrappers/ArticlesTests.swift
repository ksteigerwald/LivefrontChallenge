//
//  ArticlesTests.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 1/1/23.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
import Combine
@testable import LivefrontChallenge
class ArticlesTests: XCTestCase {

    @ArticleProperty var articles: Articles


    func testSetup() {
        XCTAssertEqual(articles.isLoaded, false)
        XCTAssertEqual(articles.generatedSummaryLoaded, false)
        XCTAssertEqual(articles.firstLoad, false)
    }

    var cancellables = Set<AnyCancellable>()
    let expectation = XCTestExpectation(description: "The first publishes value is an empty section")

    func testgenerateSummaryArticleError() {

        stub(condition: isHost("api.openai.com")) { _ in
            let stubPath = OHPathForFile("GeneratedArticle.json", JSONReusable.self)
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }

        let category = NewsCategory(name: "YCombinator")
        articles
            .generateSummaryArticle(
                category: category,
                articles: [
                    Article(articleURL: "https://grantisom.com/2023/01/02/mustread-books-for.html"),
                    Article(articleURL: "https://news.ycombinator.com/item?id=34219335")
                ]
            )

        articles.$generatedSummaryLoaded
            .sink { result in
                print(result)
                if result {
                    self.expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 15.0)
    }
}
