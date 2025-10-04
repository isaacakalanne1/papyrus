// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Subscription",
    platforms: [
        .iOS("17.4")
    ],
    products: [
        .library(
            name: "Subscription",
            targets: ["Subscription"]),
        .library(
            name: "SubscriptionMocks",
            targets: ["SubscriptionMocks"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/isaacakalanne1/reduxkit.git", from: "1.0.1"),
        .package(name: "Settings", path: "../Settings")
    ],
    targets: [
        .target(
            name: "Subscription",
            dependencies: [
                .product(name: "ReduxKit", package: "reduxkit"),
                "Settings"
            ]),
        .target(
            name: "SubscriptionMocks",
            dependencies: [
                "Subscription",
                "Settings",
                .product(name: "SettingsMocks", package: "Settings")
            ],
            path: "Mocks"
        ),
        .testTarget(
            name: "SubscriptionTests",
            dependencies: ["Subscription", "SubscriptionMocks"]
        ),
    ]
)
