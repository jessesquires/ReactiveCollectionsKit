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

final class TestDiffableSnapshot: UnitTestCase, @unchecked Sendable {

    @MainActor
    func test_init() {
        let model = self.fakeCollectionViewModel()
        let sectionIds = Set(model.allSectionsByIdentifier().keys)
        let itemIds = Set(model.allCellsByIdentifier().keys)

        let snapshot = DiffableSnapshot(viewModel: model)
        XCTAssertEqual(Set(snapshot.sectionIdentifiers), sectionIds)
        XCTAssertEqual(Set(snapshot.itemIdentifiers), itemIds)

        for sectionId in snapshot.sectionIdentifiers {
            let section = model.sectionViewModel(for: sectionId)
            XCTAssertNotNil(section)

            for itemId in snapshot.itemIdentifiers(inSection: sectionId) {
                let cell = section?.cellViewModel(for: itemId)
                XCTAssertNotNil(cell)
            }
        }
    }

    @MainActor
    func test_init_empty() {
        let snapshot = DiffableSnapshot(viewModel: .empty)
        XCTAssertTrue(snapshot.sectionIdentifiers.isEmpty)
        XCTAssertTrue(snapshot.itemIdentifiers.isEmpty)
    }

    @MainActor
    func test_init_perf() {
        let model = self.fakeCollectionViewModel(numSections: 10, numCells: 10_000)
        measure {
            let snapshot = DiffableSnapshot(viewModel: model)
            XCTAssertEqual(snapshot.numberOfItems, 100_000)
        }
    }
}
