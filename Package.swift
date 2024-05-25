// swift-tools-version:5.10
// The swift-tools-version declares the minimum version
// of Swift required to build this package.
// ----------------------------------------------------
//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//  Documentation
//  https://jessesquires.github.io/ReactiveCollectionsKit
//
//  GitHub
//  https://github.com/jessesquires/ReactiveCollectionsKit
//
//  Copyright © 2019-present Jesse Squires
//

import PackageDescription

let package = Package(
    name: "ReactiveCollectionsKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ReactiveCollectionsKit",
            targets: ["ReactiveCollectionsKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(name: "ReactiveCollectionsKit", path: "Sources"),
        .testTarget(
            name: "ReactiveCollectionsKitTests",
            dependencies: ["ReactiveCollectionsKit"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
