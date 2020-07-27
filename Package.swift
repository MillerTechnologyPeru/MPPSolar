// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MPPSolar",
    products: [
        .library(
            name: "MPPSolar",
            targets: ["MPPSolar"]
        ),
        .executable(
            name: "solartool",
            targets: ["solartool"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            .upToNextMinor(from: "0.0.1")
        )
    ],
    targets: [
        .target(
            name: "solartool",
            dependencies: [
                "MPPSolar",
                "ArgumentParser"
            ],
            path: "./Sources/MPPSolarTool"
        ),
        .target(
            name: "MPPSolar",
            dependencies: ["CMPPSolar"]
        ),
        .target(
            name: "CMPPSolar",
            dependencies: []
        ),
        .testTarget(
            name: "MPPSolarTests",
            dependencies: ["MPPSolar"]
        ),
    ]
)
