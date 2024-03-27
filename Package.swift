// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-react-poc",

    products: [
        .library(
            name: "swift-react-poc",
            targets: ["swift-react-poc"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "SRTCore"
        ),
        .target(
            name: "DOMModule",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .target(name: "SRTCore")
            ]
        ),
        .testTarget(
            name: "DOMModuleTests",
            dependencies: [
                .target(name: "DOMModule")
            ]
        ),
        .target(
            name: "swift-react-poc"
        ),
        .testTarget(
            name: "swift-react-pocTests",
            dependencies: ["swift-react-poc"]
        ),
    ]
)
