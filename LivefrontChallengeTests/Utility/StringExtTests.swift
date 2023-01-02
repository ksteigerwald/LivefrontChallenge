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

        let parts = doc.parseHeadlineAndBody()
        let heading = parts?.headline
        let body = parts?.body

        XCTAssertEqual(heading, "Cryptocurrency Market Sees Shifts in Rankings as Prices Fluctuate:")
        XCTAssertEqual(body, "The cryptocurrency market has seen a number of changes in recent weeks, with Algorand (ALGO), Apecoin (APE), Bitcoin (BTC), Ethereum (ETH), Vechain (VET), Ark (ARK), Solana (SOL), The Sandbox (SAND), Flasko (FLS), HDUP (HDUP) and Atom (ATOM) all experiencing price fluctuations. ALGO and SOL prices are looking to recover, while ARK has been predicted to be a good investment in 2022-2031. FLS, HDUP, and SAND have been suggested as coins to invest in for a profitable 2023, with ALGO being predicted to have a bullish outlook. Despite this, ALGO has been experiencing high selling pressure, causing its prices to backtrack. Investors should be aware of the potential risks and rewards of investing in these cryptocurrencies.")
    }

    func testSummaryHeadlineParsing() {
        let doc: String = "\n\nHeadline: Arbitrum Launches Dex Trader Joe on Multiple Chains\n\nParagraph 1: Arbitrum, an Ethereum-compatible Layer 2 scaling solution, has launched its decentralized exchange (DEX) Trader Joe on multiple blockchains. The DEX is designed to facilitate the transfer of digital assets between different blockchains.\n\nParagraph 2: The launch of Trader Joe on Arbitrum follows a trend of decentralized exchanges (DEXs) migrating to multiple chains. The move is seen as a way of mitigating risk, as well as increasing liquidity and reducing transaction costs.\n\nParagraph 3: Trader Joe is a non-custodial DEX built on the Arbitrum protocol. It allows users to trade digital assets on multiple chains, including Ethereum, Bitcoin, and Binance Smart Chain.\n\nParagraph 4: The DEX is designed to provide a secure and user-friendly experience, with features such as multi-chain support, atomic swaps, and a decentralized order book.\n\nParagraph 5: According to Arbitrum CEO and co-founder, Joe Petrowski, the launch of Trader Joe on the platform is a major milestone for Arbitrum and the DEX.\n\nParagraph 6: Petrowski believes that the launch of Trader Joe on Arbitrum will help to further increase liquidity and reduce transaction costs. He also believes that the DEX will help to further increase the adoption of Arbitrum.\n\nParagraph 7: The launch of Trader Joe on Arbitrum is seen as another step towards the further decentralization of the cryptocurrency market, as well as the increased adoption of multiple blockchains."

        let parts = doc.parseHeadlineAndBody()
        let heading = parts?.headline
        let body = parts?.body
        XCTAssertEqual(heading, "Headline: Arbitrum Launches Dex Trader Joe on Multiple Chains")
        XCTAssertEqual(body!.count, 1448)

    }

}
