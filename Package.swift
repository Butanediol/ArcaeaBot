// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArcaeaBot",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.13.1"),
        .package(name: "TelegramBotSDK", url: "https://github.com/Butanediol/telegram-bot-swift", .branch("patch-1")),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "ArcaeaBot",
            dependencies: [
                "TelegramBotSDK",
                .product(name: "SQLite", package: "SQLite.swift"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "ArcaeaBotTests",
            dependencies: ["ArcaeaBot"]),
    ]
)
