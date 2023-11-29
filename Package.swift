// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Squirrel3",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v7),
    ],
    products: [
        .library(
            name: "Squirrel3",
            targets: ["Squirrel3"]
        ),
    ],
    targets: [
        .target(
            name: "Squirrel3",
            dependencies: ["CSquirrel"]
        ),
        .target(name: "CSquirrel"),
        .testTarget(
            name: "Squirrel3Tests",
            dependencies: ["Squirrel3"]
        ),
    ]
)
// Add the documentation compiler plugin if possible
#if swift(>=5.6)
    package.dependencies.append(
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    )
#endif
