//
//  CryptoCompareTests.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 12/23/22.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import LivefrontChallenge

final class CryptoCompareTests: XCTestCase {
    var service: CryptoCompareService!

    override func setUpWithError() throws {
        service = CryptoCompareService()
    }

    func testGetNewsCategories() async {

        stub(condition: isHost("min-api.cryptocompare.com")) { _ in
            let stubPath = OHPathForFile("CryptoCompareNewsCategories.json", JSONReusable.self)
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }

        let result = try! await service.getNewsCategories()
        switch result {
        case .success(let data):
            XCTAssertEqual(data.count, 63)
        case .failure(let err):
            print(err)
        }
    }

    func testGetNews() async {
        let params = CryptoCompareRequestParams(
            feeds: nil,
            categories: "XRP,ALGO",
            excludeCategories: "BTC,ETH",
            lTs: nil,
            sortOrder: nil,
            extraParams: nil,
            sign: nil
        )

        stub(condition: isHost("min-api.cryptocompare.com")) { _ in
            let stubPath = OHPathForFile("CryptoCompare.json", JSONReusable.self)
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }

        let result = try! await service.getNews(requestParams: params)
        switch result {
        case .success(let data):
            print(data)
            XCTAssertEqual(data.type, 100)
            XCTAssertEqual(data.articles.count, 50)
        case .failure(let err):
            print(err)
        }
    }
}
