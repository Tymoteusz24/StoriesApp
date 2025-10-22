// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Networking",
            targets: ["Networking"]),

        .library(
                name: "NetworkMock",
                targets: ["NetworkMock"]
            )

    ], dependencies: [
        .package(path: "../Logger"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0")
    ],
    targets: [

        .target(
            name: "Networking", dependencies: ["Logger"]),
        .target(name: "NetworkMock",
                dependencies: ["Networking",
                               .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")]
               ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking", .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"), "NetworkMock"])
    ]
)
