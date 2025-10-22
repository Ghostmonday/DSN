// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DirectorStudio",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DirectorStudio",
            targets: ["DirectorStudio"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.0"),
    ],
    targets: [
        .target(
            name: "DirectorStudio",
            dependencies: [],
            path: ".",
            sources: [
                "Core/Telemetry.swift",
                "Core/AIServiceProtocol.swift",
                "Core/CoreTypeSnapshot.swift",
                "Core/Logging.swift",
                "Core/PipelineProtocols.swift",
                "DataModels.swift",
                "DirectorStudioCore.swift",
                "MonetizationManager.swift",
                "PersistenceManager.swift",
                "SegmentationModule.swift",
                "RewordingModule.swift",
                "StoryAnalysisModule.swift",
                "TaxonomyModule.swift",
                "ContinuityModule.swift",
                "VideoGenerationModule.swift",
                "VideoAssemblyModule.swift",
                "VideoEffectsModule.swift",
                "SupportingTypes.swift",
                "CoreGUIAbstraction.swift"
            ]
        ),
        .testTarget(
            name: "DirectorStudioTests",
            dependencies: ["DirectorStudio"],
            path: "Tests",
            sources: [
                "DirectorStudioTests.swift"
            ]
        ),
    ]
)

