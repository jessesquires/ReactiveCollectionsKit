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

final class TestCollectionViewDriver: UnitTestCase {

    @MainActor
    func test_numberOfSections_numberOfItems() {
        let sections = Int.random(in: 5...10)
        let cells = Int.random(in: 5...15)
        let model = self.fakeCollectionViewModel(numSections: sections, numCells: cells)
        let driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: model,
            emptyViewProvider: nil,
            cellEventCoordinator: nil,
            didUpdate: nil
        )

        XCTAssertEqual(driver.numberOfSections, sections)

        for index in 0..<sections {
            XCTAssertEqual(driver.numberOfItems(in: index), cells)
        }
    }

    @MainActor
    func test_numberOfSections_isEmpty() {
        let driver = CollectionViewDriver(
            view: self.collectionView,
            emptyViewProvider: nil,
            cellEventCoordinator: nil,
            didUpdate: nil
        )

        XCTAssertEqual(driver.numberOfSections, .zero)
    }

    @MainActor
    func test_delegate_didSelectItemAt_calls_cellViewModel() {
        let sections = 2
        let cells = 5
        let model = self.fakeCollectionViewModel(numSections: sections, numCells: cells, expectDidSelectCell: true)
        let driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: model,
            emptyViewProvider: nil,
            cellEventCoordinator: nil,
            didUpdate: nil
        )

        for section in 0..<sections {
            for cell in 0..<cells {
                let indexPath = IndexPath(item: cell, section: section)
                driver.collectionView(self.collectionView, didSelectItemAt: indexPath)
            }
        }

        self.waitForExpectations()
    }

    @MainActor
    func test_delegate_shouldHighlight_calls_cellViewModel() {
        let cell1 = FakeTextCellViewModel(shouldHighlight: true)
        let cell2 = FakeTextCellViewModel(shouldHighlight: false)
        let section = SectionViewModel(id: "section", cells: [cell1, cell2])
        let collection = CollectionViewModel(id: "collection", sections: [section])

        let driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: collection,
            emptyViewProvider: nil,
            cellEventCoordinator: nil,
            didUpdate: nil
        )

        let highlight1 = driver.collectionView(self.collectionView, shouldHighlightItemAt: .init(item: 0, section: 0))
        XCTAssertEqual(highlight1, cell1.shouldHighlight)

        let highlight2 = driver.collectionView(self.collectionView, shouldHighlightItemAt: .init(item: 1, section: 0))
        XCTAssertEqual(highlight2, cell2.shouldHighlight)
    }

    @MainActor
    func test_delegate_contextMenuConfigurationForItemAt_calls_cellViewModel() {
        let contextMenu = UIContextMenuConfiguration()
        let cell1 = FakeTextCellViewModel(contextMenuConfiguration: contextMenu)
        let cell2 = FakeTextCellViewModel(contextMenuConfiguration: nil)
        let section = SectionViewModel(id: "section", cells: [cell1, cell2])
        let collection = CollectionViewModel(id: "collection", sections: [section])

        let driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: collection,
            emptyViewProvider: nil,
            cellEventCoordinator: nil,
            didUpdate: nil
        )

        let menu1 = driver.collectionView(
            self.collectionView,
            contextMenuConfigurationForItemAt: .init(item: 0, section: 0),
            point: .zero
        )
        XCTAssertEqual(menu1, cell1.contextMenuConfiguration)

        let menu2 = driver.collectionView(
            self.collectionView,
            contextMenuConfigurationForItemAt: .init(item: 1, section: 0),
            point: .zero
        )
        XCTAssertEqual(menu2, cell2.contextMenuConfiguration)
    }

    @MainActor
    func test_dataSource_cellForItemAt_calls_cellViewModel_configure() {
        let sections = 2
        let cells = 5
        let model = self.fakeCollectionViewModel(numSections: sections, numCells: cells, expectConfigureCell: true)

        let viewController = self.viewController
        let driver = CollectionViewDriver(
            view: viewController.collectionView,
            viewModel: model,
            emptyViewProvider: nil,
            cellEventCoordinator: nil,
            didUpdate: nil
        )
        _ = driver

        self.simulateViewControllerAppearance()

        self.waitForExpectations()
    }
}
