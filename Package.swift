// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LanguageList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "LanguageList",
            targets: ["LanguageList"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/SwiftPackageRepository/ISO639.swift.git",
            revision: "92cb77c9b0da6ec1d9ad5fd8043257c90ccc0a65"
        ),
    ],
    targets: [
        .target(
            name: "LanguageList",
            dependencies: [
                .product(name: "ISO639", package: "ISO639.swift"),
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "LanguageListTests",
            dependencies: ["LanguageList"]),
    ]
)
