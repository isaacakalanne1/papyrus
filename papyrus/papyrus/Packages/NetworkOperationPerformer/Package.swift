// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkOperationPerformer",
    platforms: [
        .iOS("17.4")
    ],
    products: [
        .library(
            name: "NetworkOperationPerformer",
            targets: ["NetworkOperationPerformer"]
        ),
        .library(
            name: "NetworkOperationPerformerMocks",
            targets: ["NetworkOperationPerformerMocks"]
        ),
        .executable(
            name: "DemoNetworkOperationPerformer",
            targets: ["DemoNetworkOperationPerformer"]
        )
    ],
    targets: [
        .target(
            name: "NetworkOperationPerformer",
            dependencies: []
        ),
        .target(
            name: "NetworkOperationPerformerMocks",
            dependencies: [
                "NetworkOperationPerformer"
            ],
            path: "Mocks"
        ),
        .executableTarget(
            name: "DemoNetworkOperationPerformer",
            dependencies: [
                "NetworkOperationPerformer",
                "NetworkOperationPerformerMocks"
            ],
            path: "Examples"
        ),
        .testTarget(
            name: "NetworkOperationPerformerTests",
            dependencies: [
                "NetworkOperationPerformer",
                "NetworkOperationPerformerMocks"
            ]
        )
    ]
)
