// swift-tools-version: 5.10

import PackageDescription

func swiftSettings() -> [SwiftSetting] {
    return [
        .enableUpcomingFeature("ForwardTrailingClosures"),
        .enableUpcomingFeature("ConciseMagicFile"),
        .enableUpcomingFeature("BareSlashRegexLiterals"),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("IsolatedDefaultValues"),
        .enableUpcomingFeature("DeprecateApplicationMain"),
        .enableUpcomingFeature("DisableOutwardActorInference"),
        .enableUpcomingFeature("ImportObjcForwardDeclarations"),
        .enableExperimentalFeature("AccessLevelOnImport")
    ]
}

let usesJavaScriptKitOnMac = true

let javaScriptKitShimTarget: PackageDescription.Target = {
    var deps: [PackageDescription.Target.Dependency] = []

    if usesJavaScriptKitOnMac {
        deps += [
            .product(name: "JavaScriptKit", package: "JavaScriptKit")
        ]
    } else {
        deps += [
            .product(name: "JavaScriptKit", package: "JavaScriptKit", condition: .when(platforms: [.wasi])),
            .target(name: "JavaScriptKitMock", condition: .when(platforms: [.macOS]))
        ]
    }

    return .target(
        name: "JavaScriptKitShim",
        dependencies: deps
    )
}()

let package = Package(
    name: "swift-react",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "React", targets: ["React"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.19.1"),
    ],
    targets: [
        .target(
            name: "SRTCore",
            swiftSettings: swiftSettings()
        ),
        .target(
            name: "WebMock",
            swiftSettings: swiftSettings()
        ),
        .target(
            name: "JavaScriptKitMock",
            dependencies: [
                .target(name: "SRTCore")
            ],
            swiftSettings: swiftSettings()
        ),
        javaScriptKitShimTarget,
        .target(
            name: "DOMModule",
            dependencies: [
                .target(name: "SRTCore"),
                .target(name: "JavaScriptKitShim")
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
