// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Squirrel3",
    products: [
        .library(
            name: "Squirrel3",
            targets: ["Squirrel3"]),
    ],
    targets: [
        .target(
            name: "Squirrel3",
            dependencies: ["CSquirrel"]),
        .target(name: "CSquirrel"),
        .testTarget(
            name: "Squirrel3Tests",
            dependencies: ["Squirrel3"]),
    ]
)
