// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ASKCore",
    platforms: [
        .macOS(.v11),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ASKCore",
            targets: ["ASKCore"]),
    ],
    dependencies: [
		.package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.1"),
		.package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", from: "2.8.1")
    ],
    targets: [
        .target(
            name: "ASKCore",
            dependencies: [
	            "Swinject",
				"SwinjectAutoregistration"
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
