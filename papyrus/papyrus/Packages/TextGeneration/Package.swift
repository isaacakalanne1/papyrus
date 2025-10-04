// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextGeneration",
    platforms: [
        .iOS("17.4")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TextGeneration",
            targets: ["TextGeneration"]),
        .library(
            name: "TextGenerationMocks",
            targets: ["TextGenerationMocks"]
        ),
    ],
    dependencies: [
        .package(name: "Settings", path: "../Settings"),
        .package(name: "SDNetworkCore", path: "../SDNetworkCore")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TextGeneration",
            dependencies: [
                "Settings",
                "SDNetworkCore"
            ]),
        .target(
            name: "TextGenerationMocks",
            dependencies: [
                "TextGeneration"
            ],
            path: "Mocks"
        ),
        .testTarget(
            name: "TextGenerationTests",
            dependencies: [
                "TextGeneration",
                "TextGenerationMocks",
                "SDNetworkCore"
            ]
        ),
    ]
)
