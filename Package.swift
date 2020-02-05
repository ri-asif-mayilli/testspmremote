// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ClientSecurityKit",
    products: [
        .library(
            name: "ClientSecurityKit",
            targets: ["ClientSecurityKit"]),
    ],
    targets: [
        .target(
            name: "ClientSecurityKit",
            path: "."),
    ]
)
