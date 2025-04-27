// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ASKCore",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ASKCore",
            targets: ["ASKCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/cashapp/knit.git", branch: "skorulis/spm-plugin")
    ],
    targets: [
        .target(
            name: "ASKCore",
            dependencies: [
                .product(name: "Knit", package: "knit")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ASKCoreUnitTests",
            dependencies: ["ASKCore"],
            path: "UnitTests"
            ),
    ]
)
