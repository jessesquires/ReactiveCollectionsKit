// swift-tools-version:6.0
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
            path: "Tests",
            resources: [
                .process("Fakes/FakeCellNib.xib"),
                .process("Fakes/FakeSupplementaryNib.xib")
            ]
        )
    ],
    swiftLanguageModes: [.v5]
)

#warning("Remove after Swift 6 language mode")
let swiftSettings = [
    SwiftSetting.enableExperimentalFeature("StrictConcurrency")
]

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(contentsOf: swiftSettings)
    target.swiftSettings = settings
}
