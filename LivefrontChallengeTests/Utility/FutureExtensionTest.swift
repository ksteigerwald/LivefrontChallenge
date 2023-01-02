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
    var cancellables = Set<AnyCancellable>()
    func testAsyncFunction() {
        let expectation = self.expectation(description: "asyncFunc")

        let future = Future<Int, Error> { promise in
            Task.init {
                promise(.success(5))
            }
        }
        future.sink(
            receiveCompletion: { _ in },
            receiveValue: { value in
                XCTAssertEqual(value, 5)
                expectation.fulfill()
            }
        ).store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}
