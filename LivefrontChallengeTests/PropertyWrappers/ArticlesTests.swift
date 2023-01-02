//
//  ArticlesTests.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 1/1/23.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import LivefrontChallenge
class ArticlesTests: XCTestCase {

    @ArticleProperty var articles: Articles


    func testSetup() {
        XCTAssertEqual(articles.isLoaded, false)
        XCTAssertEqual(articles.generatedSummaryLoaded, false)
        XCTAssertEqual(articles.firstLoad, false)
    }

    func testgenerateSummaryArticle() {
        let category = NewsCategory(name: "XRP")
        articles.generateSummaryArticle(category: category, articles: [])
    }
}
