// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NimbleFeedback",
    products: [
        .library(name: "NimbleFeedback", targets: ["NimbleFeedback"])
    ],
    dependencies: [
        .package(name: "Nimble", url: "https://github.com/quick/nimble.git", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(
            name: "NimbleFeedback",
            dependencies: ["Nimble"]
        ),
        .testTarget(
            name: "NimbleFeedbackTests",
            dependencies: ["NimbleFeedback"]
        )
    ]
)
