// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DirectorStudio",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "DirectorStudioKit",
            targets: ["DirectorStudioKit"]
        ),
        .executable(
            name: "DirectorStudioApp",
            targets: ["DirectorStudioApp"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        // MARK: - App Target
        .executableTarget(
            name: "DirectorStudioApp",
            dependencies: ["DirectorStudioKit"],
            path: "App",
            resources: [
                .process("Resources")
            ]
        ),

        // MARK: - Main Library Target
        .target(
            name: "DirectorStudioKit",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Modules"
        ),

        // MARK: - Test Target
        .testTarget(
            name: "DirectorStudioTests",
            dependencies: ["DirectorStudioKit"],
            path: "Tests"
        ),
    ]
)

