// swift-tools-version: 5.9

import PackageDescription

// for development
let usesJavaScriptKitMockOnMac = false
let usesLocalJavaScriptKit = false

let javaScriptKitDependency: Package.Dependency = usesLocalJavaScriptKit ?
    .package(path: "../../swiftwasm/JavaScriptKit") :
    .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.19.2")

let javaScriptKitMockPlatforms: [Platform] = [
    usesJavaScriptKitMockOnMac ? .macOS : nil,
    .linux
].compacted()

let javaScriptKitRealPlatforms: [Platform] = javaScriptKitMockPlatforms.inverted()

let javaScriptKitMockFlag: SwiftSetting? = javaScriptKitMockPlatforms.isEmpty ? nil :
    .define("USES_JAVASCRIPT_KIT_MOCK", .when(platforms: javaScriptKitMockPlatforms))

let dependencyToJavaScriptKitReal: Target.Dependency? = javaScriptKitRealPlatforms.isEmpty ? nil :
    .product(
        name: "JavaScriptKit", package: "JavaScriptKit",
        condition: .when(platforms: javaScriptKitRealPlatforms)
    )

let dependencyToJavaScriptKitMock: Target.Dependency? = javaScriptKitMockPlatforms.isEmpty ? nil :
    .target(
        name: "JavaScriptKitMock",
        condition: .when(platforms: javaScriptKitMockPlatforms)
    )

let dependencyToWebMock: Target.Dependency? = javaScriptKitMockPlatforms.isEmpty ? nil :
    .target(
        name: "WebMock",
        condition: .when(platforms: javaScriptKitMockPlatforms)
    )

var targets: [Target] = []

targets += [
    .target(
        name: "SRTCore",
        dependencies: [
            .product(name: "Algorithms", package: "swift-algorithms")
        ],
        swiftSettings: swiftSettings()
    )
]

targets += [
    .target(
        name: "JavaScriptKitMock",
        dependencies: [
            .target(name: "SRTCore")
        ],
        swiftSettings: swiftSettings()
    ),
    .target(
        name: "WebMock",
        dependencies: [
            .target(name: "JavaScriptKitMock")
        ],
        swiftSettings: swiftSettings()
    ),
    .target(
        name: "JavaScriptKitShim",
        dependencies: [
            dependencyToJavaScriptKitReal,
            dependencyToJavaScriptKitMock
        ].compacted(),
        swiftSettings: swiftSettings()
    ),
    .target(
        name: "SRTJavaScriptKitEx",
        dependencies: [
            .target(name: "SRTCore"),
            .target(name: "JavaScriptKitShim")
        ],
        swiftSettings: swiftSettings()
    )
]

targets += [
    .target(
        name: "SRTDOM",
        dependencies: [
            .target(name: "SRTCore"),
            .target(name: "SRTJavaScriptKitEx")
        ],
        swiftSettings: swiftSettings()
    )
]

targets += [
    .target(
        name: "React",
        dependencies: [
            .target(name: "SRTCore"),
            .target(name: "SRTDOM"),
        ],
        swiftSettings: swiftSettings()
    )
]

targets += [
    .target(
        name: "SRTTestSupport",
        dependencies: [
            .target(name: "SRTCore"),
            .target(name: "SRTJavaScriptKitEx"),
            dependencyToWebMock
        ].compacted(),
        swiftSettings: swiftSettings()
    )
]

targets += [
    .testTarget(
        name: "JavaScriptKitTests",
        dependencies: [
            .target(name: "SRTTestSupport")
        ],
        swiftSettings: swiftSettings()
    ),
    .testTarget(
        name: "WebMockTests",
        dependencies: [
            .target(name: "SRTTestSupport"),
            .target(name: "WebMock")
        ],
        swiftSettings: swiftSettings()
    ),
    .testTarget(
        name: "SRTDOMTests",
        dependencies: [
            .target(name: "SRTTestSupport"),
            .target(name: "SRTDOM"),
            dependencyToWebMock
        ].compacted(),
        swiftSettings: swiftSettings()
    ),
    .testTarget(
        name: "ReactTests",
        dependencies: [
            .target(name: "SRTTestSupport"),
            .target(name: "React"),
            dependencyToWebMock
        ].compacted(),
        swiftSettings: swiftSettings()
    )
]

let package = Package(
    name: "swift-react",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "React", targets: ["React"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
        javaScriptKitDependency
    ],
    targets: targets
)

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
        .enableExperimentalFeature("AccessLevelOnImport"),
        javaScriptKitMockFlag
    ].compacted()
}

extension Platform {
    static let allCases: [Platform] = [
        .macOS, .macCatalyst, .iOS, .tvOS, .watchOS, .visionOS, .driverKit,
        .linux, .android, .windows, .wasi, .openbsd
    ]
}

extension [Platform] {
    func inverted() -> [Platform] {
        Platform.allCases.filter { !contains($0) }
    }
}

extension Sequence {
    func compacted<T>() -> [T] where Element == T? {
        compactMap { $0 }
    }
}

extension Optional {
    func asArray() -> [Wrapped] {
        map { [$0] } ?? []
    }
}
