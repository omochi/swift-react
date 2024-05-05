// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "srt-codegen",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "srt-codegen",
            targets: ["srt-codegen"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.0"),
        .package(url: "https://github.com/omochi/CodegenKit", from: "1.4.1")
    ],
    targets: [
        .target(
            name: "SRTCodegen",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "CodegenKit", package: "CodegenKit")
            ]
        ),
        .executableTarget(
            name: "srt-codegen",
            dependencies: [
                .target(name: "SRTCodegen")
            ]
        )
    ]
)
