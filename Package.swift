// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Sanitize",
    products: [
        .library(name: "Sanitize", targets: ["Sanitize"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .exact("3.0.0-alpha.x"))
    ],
    targets: [
        .target(name: "Sanitize", dependencies: ["Vapor"]),
        .testTarget(name: "SanitizeTests", dependencies: ["Sanitize"])
    ]
)
