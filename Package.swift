import PackageDescription

let package = Package(
    name: "Sanitize",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ]
)