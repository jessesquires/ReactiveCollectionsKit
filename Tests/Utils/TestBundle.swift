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

import Foundation

extension Bundle {
    static var testBundle: Bundle {
        let bundle = Bundle(for: BundleFinder.self)

        // building and testing via Package.swift
        let swiftPackageBundleName = "ReactiveCollectionsKit_ReactiveCollectionsKitTests.bundle"
        if let swiftPackageBundleURL = bundle.resourceURL?.appendingPathComponent(swiftPackageBundleName),
           let swiftPackageBundle = Bundle(url: swiftPackageBundleURL) {
            return swiftPackageBundle
        }

        // building and testing via Xcode Project
        return bundle
    }
}

private final class BundleFinder { }
