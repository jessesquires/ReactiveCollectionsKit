// swift-tools-version:5.4
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

let name = "ReactiveCollectionsKit"

let package = Package(
    name: name,
    platforms: [
        .iOS(.v13)
    ],
    products: [.library(name: name,
                        targets: [name])],
    dependencies: [],
    targets: [
        .target(name: name,
                path: "Sources",
                exclude: ["Info.plist"]),
        .testTarget(name: "ReactiveCollectionsKitTests",
                    dependencies: ["ReactiveCollectionsKit"],
                    path: "Tests",
                    exclude: ["Info.plist"])
    ],
    swiftLanguageVersions: [.v5]
)
