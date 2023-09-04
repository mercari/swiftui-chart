// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "SwiftUIChart",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ChartCore",
            targets: [
                "ChartCore",
            ]
        ),
        .library(
            name: "LineChart",
            targets: [
                "LineChart",
            ]
        ),
    ],
    targets: [
        .target(
            name: "ChartCore"
        ),
        .testTarget(
            name: "ChartCoreTests",
            dependencies: [
                "ChartCore",
            ]
        ),
        .target(
            name: "LineChart",
            dependencies: [
                "ChartCore",
            ]
        ),
        .testTarget(
            name: "LineChartTests",
            dependencies: [
                "LineChart",
            ]
        ),
    ]
)
