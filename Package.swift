// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "KeyboardMan",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "KeyboardMan",
            targets: ["KeyboardMan"]
        ),
    ],
    targets: [
        .target(name: "KeyboardMan"),
    ]
)
