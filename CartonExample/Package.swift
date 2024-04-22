// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TicTacToe",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/carton", from: "1.0.3"),
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "TicTacToe",
            dependencies: [
                .product(name: "React", package: "swift-react")
            ],
            resources: [
                .copy("styles.css")
            ]
        )
    ]
)
