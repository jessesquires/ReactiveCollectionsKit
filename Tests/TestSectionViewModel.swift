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

final class TestSectionViewModel: XCTestCase {

    func test_section_with_only_cells() {
        let numCells = 3
        let name = "name"
        let section = self.makeCollectionSectionViewModel(name: name, numCells: numCells)
        XCTAssertEqual(section.id, "section_name")

        XCTAssertEqual(section.count, numCells)
        XCTAssertFalse(section.isEmpty)
    }

    func test_empty_section() {
        let section = SectionViewModel(id: "name", cells: [])

        XCTAssertEqual(section.count, .zero)
        XCTAssertTrue(section.isEmpty)
    }

    func test_RandomAccessCollection_conformance() {
        let numCells = 3
        let section = self.makeCollectionSectionViewModel(numCells: numCells)

        XCTAssertEqual(section.count, section.cellViewModels.count)
        XCTAssertEqual(section.isEmpty, section.cellViewModels.isEmpty)
        XCTAssertEqual(section.startIndex, section.cellViewModels.startIndex)
        XCTAssertEqual(section.endIndex, section.cellViewModels.endIndex)
        XCTAssertEqual(section.index(after: 0), section.cellViewModels.index(after: 0))
    }
}
