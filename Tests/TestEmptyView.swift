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

final class TestEmptyView: UnitTestCase {

    @MainActor
    func test_provider() {
        let view = FakeEmptyView()
        let provider = EmptyViewProvider {
            view
        }

        XCTAssertIdentical(provider.view, view)
    }

    @MainActor
    func test_driver_displaysEmptyView() {
        let emptyView = FakeEmptyView()
        let provider = EmptyViewProvider {
            emptyView
        }

        let viewController = FakeCollectionViewController()
        let driver = CollectionViewDriver(
            view: viewController.collectionView,
            emptyViewProvider: provider
        )

        XCTAssertTrue(driver.viewModel.isEmpty)

        self.simulateAppearance(viewController: viewController)

        // Begin in empty state
        XCTAssertTrue(driver.view.subviews.contains(where: { $0 === emptyView }))

        // Update to non-empty model
        let nonEmptyExpectation = self.expectation(name: "non_empty")
        let model = self.fakeCollectionViewModel()
        driver.update(viewModel: model, animated: true) { _ in
            nonEmptyExpectation.fulfillAndLog()
        }
        self.waitForExpectations()
        XCTAssertTrue(driver.viewModel.isNotEmpty)
        XCTAssertFalse(driver.view.subviews.contains(where: { $0 === emptyView }))

        // Update to empty model
        let animationExpectation = self.expectation(name: "animation")
        driver.update(viewModel: .empty, animated: true) { _ in
            animationExpectation.fulfillAndLog()
        }
        self.waitForExpectations()
        XCTAssertTrue(driver.viewModel.isEmpty)
        XCTAssertTrue(driver.view.subviews.contains(where: { $0 === emptyView }))

        // Update to empty model "again"
        // already displaying empty view, should return early
        // also test completion block
        let completionExpectation = self.expectation(name: "completion")
        driver.update(viewModel: .empty, animated: false) { _ in
            completionExpectation.fulfillAndLog()
        }
        self.waitForExpectations()
        XCTAssertTrue(driver.viewModel.isEmpty)
        let emptyViews = driver.view.subviews.filter { $0 is FakeEmptyView }
        XCTAssertEqual(emptyViews.count, 1)

        self.keepDriverAlive(driver)
    }
}
