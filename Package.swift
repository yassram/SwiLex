// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwiLex",
    products: [
        .library(name: "SwiLex", targets: ["SwiLex"]),
    ],
    targets: [
        .target(name: "SwiLex"),
        .testTarget(name: "SwiLexTests", dependencies: ["SwiLex"]),
    ]
)
