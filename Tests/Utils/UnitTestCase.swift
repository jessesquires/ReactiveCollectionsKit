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
@testable import ReactiveCollectionsKit
import XCTest

// swiftlint:disable:next final_test_case
class UnitTestCase: XCTestCase, @unchecked Sendable {

    private static let frame = CGRect(x: 0, y: 0, width: 320, height: 600)

    @MainActor var collectionView: FakeCollectionView {
        FakeCollectionView(
            frame: Self.frame,
            collectionViewLayout: self.layout
        )
    }

    @MainActor let layout = FakeCollectionLayout()

    var keepAliveDrivers = [CollectionViewDriver]()

    var keepAliveWindows = [UIWindow]()

    override func setUp() async throws {
        try await super.setUp()
        await self.collectionView.layoutSubviews()
        await self.collectionView.reloadData()

        self.keepAliveDrivers.removeAll()
        self.keepAliveWindows.removeAll()
    }

    @MainActor
    func simulateAppearance(viewController: UIViewController) {
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()

        let window = UIWindow()
        window.frame = Self.frame
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        self.keepAliveWindows.append(window)
    }

    @MainActor
    func keepDriverAlive(_ driver: CollectionViewDriver) {
        self.keepAliveDrivers.append(driver)
    }
}
