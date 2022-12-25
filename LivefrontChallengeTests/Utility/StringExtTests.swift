//
//  StringExtTests.swift
//  LivefrontChallengeTests
//
//  Created by Kris Steigerwald on 12/25/22.
//

import XCTest
@testable import LivefrontChallenge

final class StringExtTests: XCTestCase {

    func testStringParse() throws {
        let doc: String = "\n\nCryptocurrency Market Sees Shifts in Rankings as Prices Fluctuate:\nThe cryptocurrency market has seen a number of changes in recent weeks, with Algorand (ALGO), Apecoin (APE), Bitcoin (BTC), Ethereum (ETH), Vechain (VET), Ark (ARK), Solana (SOL), The Sandbox (SAND), Flasko (FLS), HDUP (HDUP) and Atom (ATOM) all experiencing price fluctuations. ALGO and SOL prices are looking to recover, while ARK has been predicted to be a good investment in 2022-2031. FLS, HDUP, and SAND have been suggested as coins to invest in for a profitable 2023, with ALGO being predicted to have a bullish outlook. Despite this, ALGO has been experiencing high selling pressure, causing its prices to backtrack. Investors should be aware of the potential risks and rewards of investing in these cryptocurrencies."

        let parts = doc.parseHeadlineAndBody() ?? []
        guard let heading = parts.first, let body = parts.last else { return }
        XCTAssertEqual(heading, "Cryptocurrency Market Sees Shifts in Rankings as Prices Fluctuate:")
        XCTAssertEqual(body, "The cryptocurrency market has seen a number of changes in recent weeks, with Algorand (ALGO), Apecoin (APE), Bitcoin (BTC), Ethereum (ETH), Vechain (VET), Ark (ARK), Solana (SOL), The Sandbox (SAND), Flasko (FLS), HDUP (HDUP) and Atom (ATOM) all experiencing price fluctuations. ALGO and SOL prices are looking to recover, while ARK has been predicted to be a good investment in 2022-2031. FLS, HDUP, and SAND have been suggested as coins to invest in for a profitable 2023, with ALGO being predicted to have a bullish outlook. Despite this, ALGO has been experiencing high selling pressure, causing its prices to backtrack. Investors should be aware of the potential risks and rewards of investing in these cryptocurrencies.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
