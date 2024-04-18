// swift-tools-version: 5.9

import PackageDescription

var products: [Product] = []
var targets: [Target] = []

func addPage(name: String) {
    targets.append(
        .executableTarget(
            name: name,
            dependencies: [
                .product(name: "React", package: "swift-react"),
                .target(name: "BRTSupport")
            ]
        )
    )
    products.append(
        .executable(name: name, targets: [name])
    )
}

addPage(name: "QSComponents")
addPage(name: "QSMarkup")
addPage(name: "QSDisplayingData")

let package = Package(
    name: "BrowserTests",
    platforms: [.macOS(.v14)],
    products: products + [
        .executable(name: "gen-pages", targets: ["gen-pages"])
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .target(
            name: "BRTSupport",
            dependencies: [
                .product(name: "React", package: "swift-react")
            ]
        )
    ] + targets + [
        .target(
            name: "GenPagesModule",
            swiftSettings: [.enableUpcomingFeature("BareSlashRegexLiterals")]
        ),
        .executableTarget(
            name: "gen-pages",
            dependencies: [
                .target(name: "GenPagesModule", condition: .when(platforms: [.macOS]))
            ]
        )
    ]
)
