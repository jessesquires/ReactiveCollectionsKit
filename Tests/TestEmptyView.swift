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

final class TestEmptyView: UnitTestCase {

    @MainActor
    func test_provider() {
        let view = UILabel()
        view.text = "text"
        let provider = EmptyViewProvider {
            view
        }

        XCTAssertIdentical(provider.view, view)
    }

    @MainActor
    func test_driver_displaysEmptyView() {
        let emptyView = UILabel()
        emptyView.text = "Empty"
        let provider = EmptyViewProvider {
            emptyView
        }

        let viewController = FakeCollectionViewController()
        let driver = CollectionViewDriver(
            view: viewController.collectionView,
            options: .test(),
            emptyViewProvider: provider
        )

        XCTAssertTrue(driver.viewModel.isEmpty)

        self.simulateAppearance(viewController: viewController)
        XCTAssertTrue(driver.view.subviews.contains(where: { $0 === emptyView }))

        let model = self.fakeCollectionViewModel()
        driver.update(viewModel: model, animated: false)
        XCTAssertTrue(driver.viewModel.isNotEmpty)
        XCTAssertFalse(driver.view.subviews.contains(where: { $0 === emptyView }))

        driver.update(viewModel: CollectionViewModel(id: "new_empty"), animated: false)
        XCTAssertTrue(driver.viewModel.isEmpty)
        XCTAssertTrue(driver.view.subviews.contains(where: { $0 === emptyView }))

        self.keepDriverAlive(driver)
    }
}
