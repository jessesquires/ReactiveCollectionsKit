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

@testable import ReactiveCollectionsKit
import XCTest

open class UnitTestCase: XCTestCase {

    private static let frame = CGRect(x: 0, y: 0, width: 320, height: 600)

    @MainActor var collectionView: FakeCollectionView {
        FakeCollectionView(
            frame: Self.frame,
            collectionViewLayout: FakeCollectionLayout()
        )
    }

    @MainActor var keepAliveDrivers = [CollectionViewDriver]()

    @MainActor var keepAliveWindows = [UIWindow]()

    @MainActor
    override open func setUp() {
        super.setUp()
        self.collectionView.layoutSubviews()
        self.collectionView.reloadData()

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
