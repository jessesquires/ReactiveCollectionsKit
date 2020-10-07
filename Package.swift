// swift-tools-version:5.3
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
        .iOS(.v13)
    ],
    products: [.library(name: "ReactiveCollectionsKit",
                        targets: ["ReactiveCollectionsKit"])],
    dependencies: [],
    targets: [
        .target(name: "ReactiveCollectionsKit",
                path: "Sources",
                exclude: ["Info.plist"]),
        .testTarget(name: "ReactiveCollectionsKitTests",
                    dependencies: ["ReactiveCollectionsKit"],
                    path: "Tests",
                    exclude: ["Info.plist"])
    ],
    swiftLanguageVersions: [.v5]
)
