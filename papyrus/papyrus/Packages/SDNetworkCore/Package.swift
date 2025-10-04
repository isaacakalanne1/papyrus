// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDNetworkCore",
    platforms: [
        .iOS("17.4")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SDNetworkCore",
            targets: ["SDNetworkCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "12.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SDNetworkCore",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "SDNetworkCoreTests",
            dependencies: ["SDNetworkCore"]
        ),
    ]
)
