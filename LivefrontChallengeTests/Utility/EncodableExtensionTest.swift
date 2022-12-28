//
//  EncodableExtensionTest.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 12/28/22.
//

import XCTest
@testable import LivefrontChallenge

class EncodableTests: XCTestCase {
    func testToDictionary() {
        struct TestObject: Encodable {
            let testString: String
            let testInt: Int
            let testBool: Bool
        }

        let testObject = TestObject(testString: "test string", testInt: 123, testBool: true).toDictionary()
        XCTAssertEqual(testObject["testString"] as! String, "test string")
    }
}
