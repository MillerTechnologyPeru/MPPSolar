// swift-tools-version:5.5
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
            targets: ["MPPSolarTool"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "MPPSolarTool",
            dependencies: [
                "MPPSolar",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ]
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
