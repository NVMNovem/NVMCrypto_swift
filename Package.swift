// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NVMCrypto",
    platforms: [
        .macOS(.v11), .iOS(.v15), .tvOS(.v15)
    ],
    products: [
        .library(
            name: "NVMCrypto",
            targets: ["NVMCrypto"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NVMCrypto",
            dependencies: []),
        .testTarget(
            name: "NVMCryptoTests",
            dependencies: ["NVMCrypto"]),
    ]
)
