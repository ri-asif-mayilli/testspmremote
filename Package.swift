/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
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
