// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Domain",
            targets: ["Domain"]),
        .library(name: "DomainData",
                 targets: ["DomainData"]),
        .library(name: "DomainDataMock",
                 targets: ["DomainDataMock"])
    ],
    dependencies: [
        .package(path: "../Networking"),
        .package(path: "../Helpers"),
        .package(path: "../Storage"),
    ],

    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Domain",
            dependencies: [
                "Storage"
            ]
        ),
        .target(
            name: "DomainData",
            dependencies: [
                "Domain",
                "Networking",
                "Helpers",
                "Storage",
            ]
        ),
        .target(name: "DomainDataMock", dependencies: ["Domain", "DomainData"], resources: [.process("Resources")]),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain", "DomainData", "DomainDataMock", "Networking"])
    ]
)
