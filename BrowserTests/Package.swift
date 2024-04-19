// swift-tools-version: 5.9

import PackageDescription

var products: [Product] = []
var targets: [Target] = []

func addPage(name: String, resources: [String]? = nil) {
    targets.append(
        .executableTarget(
            name: name,
            dependencies: [
                .product(name: "React", package: "swift-react"),
                .target(name: "BRTSupport")
            ],
            resources: resources?.map { .copy($0) }
        )
    )
    products.append(
        .executable(name: name, targets: [name])
    )
}

addPage(name: "QSComponents")
addPage(name: "QSMarkup")
addPage(name: "QSDisplayingData", resources: ["styles.css"])
addPage(name: "QSConditional")
addPage(name: "QSLists")
addPage(name: "QSEvents")
addPage(name: "QSUpdating", resources: ["styles.css"])
addPage(name: "QSSharing", resources: ["styles.css"])
addPage(name: "TicTacToe", resources: ["styles.css"])

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
            ],
            resources: [
                .copy("common.css")
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
