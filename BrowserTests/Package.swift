// swift-tools-version: 5.9

import PackageDescription

var products: [Product] = []
var targets: [Target] = []

func addPage(name: String) {
    targets.append(
        .executableTarget(
            name: name,
            dependencies: [
                .product(name: "React", package: "swift-react")
            ]
        )
    )
    products.append(
        .executable(name: name, targets: [name])
    )
}

addPage(name: "QSComponents")

let package = Package(
    name: "BrowserTests",
    platforms: [.macOS(.v14)],
    products: products,
    dependencies: [
        .package(path: "../")
    ],
    targets: targets
)
