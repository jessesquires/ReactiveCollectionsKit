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
    func test_collectionView_numberOfSections_numberOfItems() {
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
}
