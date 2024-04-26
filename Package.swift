// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftProtected",
    platforms: [
        .iOS(.v13),
        .visionOS(.v1),
        .macOS(.v12),
        .watchOS(.v4),
        .tvOS(.v12),
        .macCatalyst(.v13),
    ],
    products: [
        .library(
            name: "SwiftProtected",
            type: .static,
            targets: ["SwiftProtected"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftProtected",
            dependencies: [
            ]),
        .testTarget(
            name: "SwiftProtectedTests",
            dependencies: [
                "SwiftProtected",
            ]),
    ]
)
