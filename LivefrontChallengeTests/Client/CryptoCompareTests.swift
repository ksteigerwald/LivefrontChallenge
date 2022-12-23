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
        
        let result = try? await service.getNews(requestParams: params)
        switch result {
        case .success(let data):
            XCTAssertEqual(data.type, 555)
        case .failure(let err):
            print(err)
        case .none:
            print("none: \(result)")
        }
    }
}
