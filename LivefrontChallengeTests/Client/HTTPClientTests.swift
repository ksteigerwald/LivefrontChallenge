//
//  HTTPClientTests.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 12/22/22.
//

import XCTest

final class HTTPClientTests: XCTestCase {
    
    func testSendRequest() {
        // Set up test objects
        let client = HTTPClient()
        let endpoint = Endpoint(url: "https://jsonplaceholder.typicode.com/posts/1", method: "GET")
        
        // Call sendRequest and store the result
        let result = client.sendRequest(endpoint: endpoint, responseModel: Post.self)
        
        // Assert that the result is what we expect
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.userId, 1)
        XCTAssertEqual(result.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        XCTAssertEqual(result.body, "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
    }
    
}
