// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MPPSolar",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
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
        ),
        .package(
            url: "https://github.com/PureSwift/Socket.git",
            branch: "main"
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
            dependencies: [
                "Socket",
                "CMPPSolar"
            ]
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
