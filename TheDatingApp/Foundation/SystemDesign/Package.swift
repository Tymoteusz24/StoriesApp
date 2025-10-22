// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SystemDesign",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SystemDesign",
            targets: ["SystemDesign"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", from: "3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SystemDesign",
            dependencies: [
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ],
            resources: [
                .process("Supporting/Images.xcassets"),
                .process("Supporting/Colors.xcassets"),
                .process("Supporting/en.lproj/Localizable.strings"),
            ]),
        .testTarget(
            name: "SystemDesignTests",
            dependencies: ["SystemDesign"]),
    ]
)
