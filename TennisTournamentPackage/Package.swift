// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TennisTournamentFeature",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TennisTournamentFeature",
            targets: ["TennisTournamentFeature"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Ch-N30/LoGGer.git", branch: "main"),
        .package(url: "https://github.com/Ch-N30/PRNDS.git", exact: "0.1.0-alpha.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TennisTournamentFeature",
            dependencies: [
                .product(name: "LoGGer", package: "LoGGer"),
                .product(name: "PRNDSSwiftUI", package: "PRNDS")
            ]
        ),
        .testTarget(
            name: "TennisTournamentFeatureTests",
            dependencies: [
                "TennisTournamentFeature"
            ]
        )
    ]
)
