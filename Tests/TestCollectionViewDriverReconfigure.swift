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

final class TestCollectionViewDriverReconfigure: UnitTestCase {

    @MainActor
    func test_reconfigure_item() async {
        var uniqueCell = MyStaticCellViewModel(name: "initial")
        uniqueCell.expectation = self.expectation(name: "initial_configure")

        let numberCells = (1...5).map { _ in
            var viewModel = FakeNumberCellViewModel()
            viewModel.expectationConfigureCell = self.expectation(name: "configure_cell_\(viewModel.id)")
            return viewModel
        }

        let section1 = SectionViewModel(id: "one", cells: numberCells)
        let section2 = SectionViewModel(id: "two", cells: [uniqueCell])
        let section3 = self.fakeSectionViewModel(id: "three")
        let model = CollectionViewModel(id: "id", sections: [section1, section2, section3])

        let viewController = FakeCollectionViewController()
        let driver = CollectionViewDriver(view: viewController.collectionView, viewModel: model)
        self.simulateAppearance(viewController: viewController)
        self.waitForExpectations()

        // Update one cell to be reconfigured
        uniqueCell = MyStaticCellViewModel(name: "updated")
        uniqueCell.expectation = self.expectation(name: "updated_configure")
        let updatedSection = SectionViewModel(id: "two", cells: [uniqueCell])
        let updatedModel = CollectionViewModel(id: "id", sections: [section1, updatedSection])
        await driver.update(viewModel: updatedModel)
        self.waitForExpectations()

        self.keepDriverAlive(driver)
    }
}

private struct MyStaticCellViewModel: CellViewModel {
    let id: UniqueIdentifier = "MyCellViewModel"
    let name: String

    var expectation: XCTestExpectation?
    func configure(cell: FakeCollectionCell) {
        expectation?.fulfillAndLog()
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.name == right.name
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
