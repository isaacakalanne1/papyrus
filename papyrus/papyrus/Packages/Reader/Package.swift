// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reader",
    platforms: [
        .iOS("17.4")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Reader",
            targets: ["Reader"]
        ),
        .library(
            name: "ReaderMocks",
            targets: ["ReaderMocks"]
        ),
    ],
    dependencies: [
        .package(name: "TextGeneration", path: "../TextGeneration"),
        .package(name: "Settings", path: "../Settings"),
        .package(name: "Subscription", path: "../Subscription"),
        .package(name: "SDIconsKit", path: "../SDIconsKit"),
        .package(name: "PapyrusStyleKit", path: "../PapyrusStyleKit"),
        .package(url: "https://github.com/isaacakalanne1/reduxkit.git", from: "1.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Reader",
            dependencies: [
                "TextGeneration",
                "Settings",
                "Subscription",
                "SDIconsKit",
                "PapyrusStyleKit",
                .product(name: "ReduxKit", package: "reduxkit")
            ]
        ),
        .target(
            name: "ReaderMocks",
            dependencies: [
                "Reader",
                "TextGeneration",
                .product(name: "TextGenerationMocks", package: "TextGeneration"),
                "Settings",
                .product(name: "SettingsMocks", package: "Settings"),
                "Subscription",
                .product(name: "SubscriptionMocks", package: "Subscription")
            ],
            path: "Mocks"
        ),
        .testTarget(
            name: "ReaderTests",
            dependencies: [
                "Reader",
                "ReaderMocks"
            ]
        ),
    ]
)
