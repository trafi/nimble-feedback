// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "NimbleFeedback",
    platforms: [
        .iOS(.v11),
    ], products: [
        .library(
            name: "NimbleFeedback",
            targets: ["NimbleFeedback"]),
    ],
    dependencies: [
        .package(url: "git@github.com:Quick/Nimble.git", from: "8.0.0"),
    ],
    targets: [
        .target(
            name: "NimbleFeedback",
            dependencies: ["Nimble"]),
    ]
)
