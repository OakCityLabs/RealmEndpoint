// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

//
//  Package.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "RealmEndpoint",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries produced by a package,
        // and make them visible to other packages.
        .library(
            name: "RealmEndpoint",
            targets: ["RealmEndpoint"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-log.git", from: "1.1.1"),
        .package(url: "https://github.com/OakCityLabs/Endpoint.git", from: "1.0.1"),
        .package(url: "https://github.com/OakCityLabs/RealmCoder.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package.
        // A target can define a module or a test suite.
        // Targets can depend on other targets in this package,
        // and on products in packages which this package depends on.
        .target(
            name: "RealmEndpoint",
            dependencies: ["Endpoint", "RealmCoder", "Logging"]),
        .testTarget(
            name: "RealmEndpointTests",
            dependencies: ["RealmEndpoint"])
    ]
)
