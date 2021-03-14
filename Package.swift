// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-PostgreSQL",
    products: [
        .library(name: "CPostgreSQL", targets: ["CPostgreSQL"]),
        .library(name: "SwiftPostgreSQL", targets: ["SwiftPostgreSQL"]),
    ],
    targets: [
        .systemLibrary(name: "CPostgreSQL"),
        .target(name: "SwiftPostgreSQL", dependencies: ["CPostgreSQL"])
    ]
)
