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
    name: "ReactiveCollectionsKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [.library(name: "ReactiveCollectionsKit",
                        targets: ["ReactiveCollectionsKit"])],
    dependencies: [],
    targets: [
        .target(name: "ReactiveCollectionsKit",
                path: "Sources"),
        .testTarget(name: "ReactiveCollectionsKitTests",
                    dependencies: ["ReactiveCollectionsKit"],
                    path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)
