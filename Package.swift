// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LivefrontChallenge",
    products: [
        .library(
            name: "LivefrontChallenge",
            targets: ["LivefrontChallenge"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.0"),
        .package(url: "https://github.com/jegnux/BackedCodable", from: "0.1.1"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0")
    ],
    targets: [
        .target(
            name: "LivefrontChallenge",
            dependencies: ["SwiftGenPlugin", "BackedCodable"]),
        .testTarget(name: "LivefrontChallengeTests",
            dependencies: [
                "LivefrontChallenge",
                "OHHTTPStubs"])
    ]
)
