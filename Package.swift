// swift-tools-version: 5.10

import PackageDescription

func swiftSettings() -> [SwiftSetting] {
    return [
        .enableExperimentalFeature("AccessLevelOnImport")
    ]
}

let package = Package(
    name: "swift-react",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "React", targets: ["React"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SRTCore",
            swiftSettings: swiftSettings()
        ),
        .target(
            name: "DOMModule",
            dependencies: [
                .target(name: "SRTCore")
            ],
            swiftSettings: swiftSettings()
        ),
        .target(
            name: "ReactInterface",
            dependencies: [
                .target(name: "SRTCore"),
                .target(name: "DOMModule")
            ],
            swiftSettings: swiftSettings()
        ),
        .target(
            name: "VDOMModule",
            dependencies: [
                .target(name: "DOMModule"),
                .target(name: "ReactInterface")
            ],
            swiftSettings: swiftSettings()
        ),
        .target(
            name: "React",
            dependencies: [
                .target(name: "DOMModule"),
                .target(name: "VDOMModule")
            ],
            swiftSettings: swiftSettings()
        ),
        .target(
            name: "SRTTestSupport",
            dependencies: [
                .target(name: "DOMModule")
            ]
        ),
        .testTarget(
            name: "DOMModuleTests",
            dependencies: [
                .target(name: "SRTTestSupport"),
                .target(name: "DOMModule")
            ],
            swiftSettings: swiftSettings()
        ),
        .testTarget(
            name: "VDOMModuleTests",
            dependencies: [
                .target(name: "SRTTestSupport"),
                .target(name: "VDOMModule")
            ],
            swiftSettings: swiftSettings()
        ),
        .testTarget(
            name: "ReactTests",
            dependencies: [
                .target(name: "SRTTestSupport"),
                .target(name: "React")
            ],
            swiftSettings: swiftSettings()
        )
    ]
)
