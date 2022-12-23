//
//  HTTPClientTests.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 12/22/22.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import LivefrontChallenge

final class HTTPClientTests: XCTestCase {
    var service: JSONPlaceHolderService!

    override func setUpWithError() throws {
        self.service = JSONPlaceHolderService()
    }
 
    func testSendRequest() async {
        stub(condition: isHost("jsonplaceholder.typicode.com")) { _ in
            let stubPath = OHPathForFile("JSONPlaceholder.json", JSONReusable.self)
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }

        let result = try! await service.getPosts(article: 1)
        switch result {
        case .success(let data):
            XCTAssertEqual(data.id, 1)
            XCTAssertEqual(data.userId, 1)
            XCTAssertEqual(data.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        case .failure(let err):
            print(err)
        }
    }
    
}
