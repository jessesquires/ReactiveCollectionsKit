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

    @MainActor
    func test_section_with_only_cells() {
        let numCells = 3
        let name = "name"
        let section = self.fakeSectionViewModel(id: name, numCells: numCells)
        XCTAssertEqual(section.id, "section_name")

        XCTAssertEqual(section.count, numCells)
        XCTAssertFalse(section.isEmpty)
    }

    @MainActor
    func test_empty_section() {
        let section = SectionViewModel(id: "name")

        XCTAssertEqual(section.count, .zero)
        XCTAssertTrue(section.isEmpty)
    }

    @MainActor
    func test_RandomAccessCollection_conformance() {
        let numCells = 3
        let section = self.fakeSectionViewModel(numCells: numCells)

        XCTAssertEqual(section.count, section.cells.count)
        XCTAssertEqual(section.isEmpty, section.cells.isEmpty)
        XCTAssertEqual(section.startIndex, section.cells.startIndex)
        XCTAssertEqual(section.endIndex, section.cells.endIndex)
        XCTAssertEqual(section.index(after: 0), section.cells.index(after: 0))
    }
}
