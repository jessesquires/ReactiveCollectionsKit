// swift-tools-version:5.1
//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import PackageDescription

let package = Package(
    name: "DiffableCollectionsKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [.library(name: "DiffableCollectionsKit",
                        targets: ["DiffableCollectionsKit"])],
    dependencies: [],
    targets: [
        .target(name: "DiffableCollectionsKit",
                path: "Sources"),
        .testTarget(name: "DiffableCollectionsKitTests",
                    dependencies: ["DiffableCollectionsKit"],
                    path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)
