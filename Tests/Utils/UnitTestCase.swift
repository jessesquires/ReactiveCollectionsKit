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

    @MainActor let collectionView = FakeCollectionView(
        frame: frame,
        collectionViewLayout: FakeCollectionLayout()
    )

    @MainActor let window = UIWindow()

    @MainActor let viewController = FakeCollectionViewController()

    @MainActor
    override open func setUp() {
        super.setUp()
        self.collectionView.layoutSubviews()
        self.collectionView.reloadData()
    }

    @MainActor
    func simulateViewControllerAppearance() {
        self.window.frame = Self.frame
        self.window.rootViewController = self.viewController
        self.window.makeKeyAndVisible()
        self.viewController.beginAppearanceTransition(true, animated: false)
        self.viewController.endAppearanceTransition()
    }
}
