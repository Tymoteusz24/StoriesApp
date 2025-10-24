// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stories",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Stories",
            targets: ["Stories"]
        ),
    ],
    dependencies: [
        .package(path: "../../Foundation/Domain"),
        .package(path: "../../Foundation/Router"),
        .package(path: "../../Foundation/SystemDesign")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Stories",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "DomainData", package: "Domain"),
                .product(name: "DomainDataMock", package: "Domain"),
                "Router",
                "SystemDesign"
            ]
        ),
        .testTarget(
            name: "StoriesTests",
            dependencies: ["Stories"]
        ),
    ]
)
