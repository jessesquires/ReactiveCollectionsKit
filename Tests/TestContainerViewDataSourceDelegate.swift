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

final class TestContainerViewDataSourceDelegate: UnitTestCase {

    let controller = UIViewController()

    func test_collectionView_dataSource_and_delegate_methods() {
        let sections = 3
        let cells = 5

        let viewModel = self.makeCollectionViewModel(numSections: sections, numCells: cells, includeExpectations: true)
        self.collectionView._register(viewModel: viewModel)

        let dataSourceDelegate = _ContainerViewDataSourceDelegate(viewModel: viewModel,
                                                                  controller: self.controller)

        XCTAssertEqual(dataSourceDelegate.numberOfSections(in: self.collectionView), sections)

        (0..<sections).forEach {
            XCTAssertEqual(dataSourceDelegate.collectionView(self.collectionView, numberOfItemsInSection: $0), cells)
        }

        (0..<sections).forEach { section in
            (0..<cells).forEach { item in

                let indexPath = IndexPath(item: item, section: section)

                /// trigger view model `apply()` expectation
                let cell = dataSourceDelegate.collectionView(self.collectionView, cellForItemAt: indexPath)
                XCTAssertTrue(cell is FakeCollectionCell)

                /// trigger view model `didSelect` expectation
                dataSourceDelegate.collectionView(self.collectionView, didSelectItemAt: indexPath)

                let shouldHighlight = dataSourceDelegate.collectionView(self.collectionView, shouldHighlightItemAt: indexPath)
                XCTAssertTrue(shouldHighlight)

                let size = dataSourceDelegate.collectionView(self.collectionView,
                                                             layout: self.collectionView.collectionViewLayout,
                                                             sizeForItemAt: indexPath)
                let expectedSize = FakeCollectionCellViewModel.defaultSize
                XCTAssertEqual(size, expectedSize)
            }
        }

        self.waitForExpectations()
    }
}
