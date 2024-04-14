// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SYProxy",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v10_13),
    ],
    products: [
        .library(name: "SYProxy", targets: ["SYProxy"]),
    ],
    targets: [
        .target(name: "SYProxy"),
        .testTarget(name: "SYProxyTests", dependencies: ["SYProxy"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
