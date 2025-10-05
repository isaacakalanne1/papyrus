// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [
        .iOS("17.4")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Settings",
            targets: ["Settings"]),
        .library(
            name: "SettingsMocks",
            targets: ["SettingsMocks"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/isaacakalanne1/reduxkit.git", from: "1.0.1"),
        .package(name: "PapyrusStyleKit", path: "../PapyrusStyleKit")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Settings",
            dependencies: [
                "PapyrusStyleKit",
                .product(name: "ReduxKit", package: "reduxkit")
            ]),
        .target(
            name: "SettingsMocks",
            dependencies: [
                "Settings"
            ],
            path: "Mocks"
        ),
        .testTarget(
            name: "SettingsTests",
            dependencies: ["Settings", "SettingsMocks"]
        ),
    ]
)
