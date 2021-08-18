// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(macOS)
let platform = SupportedPlatform.macOS(.v10_12)
#elseif os(Linux)
let platform = SupportedPlatform.linux
#endif

let package = Package(
    name: "ArcaeaBot",
    platforms: [
        platform
    ],
    dependencies: [
        .package(name: "TelegramBotSDK", url: "https://github.com/zmeyc/telegram-bot-swift.git", .branch("master")),
        .package(url: "https://github.com/agisboye/SwiftLMDB.git", from: "2.0.0"),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ArcaeaBot",
            dependencies: [
                "TelegramBotSDK", 
                "SwiftLMDB"]),
    ]
)
