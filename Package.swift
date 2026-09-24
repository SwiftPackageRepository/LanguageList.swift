// swift-tools-version:6.0
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
            exact: "1.4.0"
        ),
        .package(
            url: "https://github.com/Webblazer/SwiftUIPlus.swift.git",
            exact: "0.2.0"
        ),
    ],
    targets: [
        .target(
            name: "LanguageList",
            dependencies: [
                .product(name: "ISO639", package: "ISO639.swift"),
                .product(name: "SwiftUIPlus", package: "SwiftUIPlus.swift"),
            ],
            resources: [.process("Resources")],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "LanguageListTests",
            dependencies: ["LanguageList"],
            swiftSettings: [.swiftLanguageMode(.v5)]),
    ]
)
