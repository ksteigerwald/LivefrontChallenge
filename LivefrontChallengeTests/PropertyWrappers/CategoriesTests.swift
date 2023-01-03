//
//  CategoriesTests.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 1/1/23.
//

import XCTest
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import LivefrontChallenge
final class CategoriesTests: XCTestCase {

    @CategoryProperty var categories
    var cancellables = Set<AnyCancellable>()
    let expectation = XCTestExpectation(description: "The first publishes value is an empty section")

    func testFetchCategories() {
        categories.fetchCategories()

        categories.$list
            .sink { value in
                XCTAssertTrue(value.isEmpty)
                self.expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }
}
