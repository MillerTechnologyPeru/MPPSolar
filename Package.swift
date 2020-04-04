// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "solartool",
            dependencies: ["MPPSolar"],
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
