// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Sanitize",
    products: [
        .library(name: "Sanitize", targets: ["Sanitize"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Sanitize", dependencies: []),
        .testTarget(name: "sanitizeTests", dependencies: ["Sanitize"]),
    ]
)
