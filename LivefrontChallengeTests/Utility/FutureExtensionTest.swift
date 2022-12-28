//
//  FutureExtensionTest.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 12/28/22.
//

import XCTest
import Combine
@testable import LivefrontChallenge

class FutureTests: XCTestCase {

    func testAsyncFunction() {
        let expectation = self.expectation(description: "asyncFunc")

        let future = Future<Int, Error> { promise in
            async {
                promise(.success(5))
            }
        }
        future.sink(
            receiveCompletion: { _ in },
            receiveValue: { value in
                XCTAssertEqual(value, 5)
                expectation.fulfill()
            }
        )

        wait(for: [expectation], timeout: 1.0)
    }
}
