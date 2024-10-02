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

final class TestCellEventCoordinator: UnitTestCase, @unchecked Sendable {

    @MainActor
    func test_underlyingViewController() {
        class CustomVC: UIViewController, CellEventCoordinator { }
        let controller = CustomVC()
        XCTAssertEqual(controller.underlyingViewController, controller)

        let coordinator = FakeCellEventCoordinator()
        XCTAssertNil(coordinator.underlyingViewController)
    }

    @MainActor
    func test_didSelectCell_getsCalled() {
        let cell = FakeCellViewModel()
        let section = SectionViewModel(id: "id", cells: [cell])
        let model = CollectionViewModel(id: "id", sections: [section])

        let coordinator = FakeCellEventCoordinator()
        coordinator.expectationDidSelect = self.expectation()

        let driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: model,
            options: .test(),
            cellEventCoordinator: coordinator
        )

        let indexPath = IndexPath(item: 0, section: 0)
        driver.collectionView(self.collectionView, didSelectItemAt: indexPath)

        self.waitForExpectations()

        self.keepDriverAlive(driver)
    }
}
