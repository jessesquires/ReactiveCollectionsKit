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

@MainActor
final class TestSectionViewModel: XCTestCase {

    func test_empty_section() {
        let section = SectionViewModel(id: "name")

        XCTAssertEqual(section.count, .zero)
        XCTAssertTrue(section.isEmpty)
    }

    func test_section_with_only_cells() {
        let numCells = 3
        let name = "section_id"
        let section = self.fakeSectionViewModel(id: name, numCells: numCells)
        XCTAssertEqual(section.id, "section_id")

        XCTAssertEqual(section.count, numCells)
        XCTAssertFalse(section.isEmpty)
    }

    func test_hasSupplementaryViews() {
        let section1 = SectionViewModel(id: "name")
        XCTAssertFalse(section1.hasSupplementaryViews)

        let section2 = self.fakeSectionViewModel(id: name, numCells: 3)
        XCTAssertFalse(section2.hasSupplementaryViews)

        let section3 = self.fakeSectionViewModel(id: name, numCells: 3, includeHeader: true)
        XCTAssertTrue(section3.hasSupplementaryViews)

        let section4 = self.fakeSectionViewModel(id: name, numCells: 3, includeFooter: true)
        XCTAssertTrue(section4.hasSupplementaryViews)

        let section5 = SectionViewModel(
            id: "id",
            cells: [FakeCellViewModel(), FakeCellViewModel()],
            supplementaryViews: [FakeSupplementaryViewModel(), FakeSupplementaryViewModel()]
        )
        XCTAssertTrue(section5.hasSupplementaryViews)
    }

    func test_cellViewModel_forId() {
        let cells = self.fakeCellViewModels(count: 10)
        let expected = cells.first!

        let section = SectionViewModel(id: "id", cells: cells.shuffled())

        XCTAssertEqual(section.cellViewModel(for: expected.id), expected)

        XCTAssertNil(section.cellViewModel(for: "nonexistent"))
    }

    func test_supplementaryViewModel_forId() {
        let expected = FakeSupplementaryViewModel()

        let section = SectionViewModel(
            id: "id",
            cells: [FakeCellViewModel(), FakeCellViewModel(), FakeCellViewModel()],
            supplementaryViews: [FakeSupplementaryViewModel(), expected, FakeSupplementaryViewModel()].shuffled()
        )

        XCTAssertEqual(section.supplementaryViewModel(for: expected.id), expected.eraseToAnyViewModel())

        XCTAssertNil(section.supplementaryViewModel(for: "nonexistent"))
    }

    func test_cell_registrations() {
        let cells1 = [FakeTextCellViewModel(), FakeTextCellViewModel(), FakeTextCellViewModel()].map { $0.eraseToAnyViewModel() }
        let cells2 = [FakeNumberCellViewModel(), FakeNumberCellViewModel(), FakeNumberCellViewModel()].map { $0.eraseToAnyViewModel() }
        let section = SectionViewModel(
            id: "id",
            cells: cells1 + cells2
        )

        let cellRegistrations = section.cellRegistrations()
        XCTAssertEqual(cellRegistrations.count, 2)
        XCTAssertTrue(cellRegistrations.contains(FakeTextCellViewModel().registration))
        XCTAssertTrue(cellRegistrations.contains(FakeNumberCellViewModel().registration))

        let section1 = SectionViewModel(id: "id", cells: cells1)
        XCTAssertEqual(section1.cellRegistrations().count, 1)

        let section2 = SectionViewModel(id: "id", cells: cells2)
        XCTAssertEqual(section2.cellRegistrations().count, 1)
    }

    func test_header_footer_registrations() {
        let cells1 = [FakeTextCellViewModel(), FakeTextCellViewModel(), FakeTextCellViewModel()].map { $0.eraseToAnyViewModel() }
        let cells2 = [FakeNumberCellViewModel(), FakeNumberCellViewModel(), FakeNumberCellViewModel()].map { $0.eraseToAnyViewModel() }
        let header = FakeHeaderViewModel()
        let footer = FakeFooterViewModel()
        let section = SectionViewModel(
            id: "id",
            cells: cells1 + cells2,
            header: header,
            footer: footer
        )

        let headerFooterRegistrations = section.headerFooterRegistrations()
        XCTAssertEqual(headerFooterRegistrations.count, 2)
        XCTAssertTrue(headerFooterRegistrations.contains(FakeHeaderViewModel().registration))
        XCTAssertTrue(headerFooterRegistrations.contains(FakeFooterViewModel().registration))
    }

    func test_supplementary_registrations() {
        let cells1 = [FakeTextCellViewModel(), FakeTextCellViewModel(), FakeTextCellViewModel()].map { $0.eraseToAnyViewModel() }
        let cells2 = [FakeNumberCellViewModel(), FakeNumberCellViewModel(), FakeNumberCellViewModel()].map { $0.eraseToAnyViewModel() }
        let views = [FakeSupplementaryViewModel(), FakeSupplementaryViewModel(), FakeSupplementaryViewModel()]
        let section = SectionViewModel(
            id: "id",
            cells: cells1 + cells2,
            supplementaryViews: views
        )

        let supplementaryViewRegistrations = section.supplementaryViewRegistrations()
        XCTAssertEqual(supplementaryViewRegistrations.count, 1)
        XCTAssertTrue(supplementaryViewRegistrations.contains(FakeSupplementaryViewModel().registration))
    }

    func test_all_registrations() {
        let cells1 = [FakeTextCellViewModel(), FakeTextCellViewModel(), FakeTextCellViewModel()].map { $0.eraseToAnyViewModel() }
        let cells2 = [FakeNumberCellViewModel(), FakeNumberCellViewModel(), FakeNumberCellViewModel()].map { $0.eraseToAnyViewModel() }
        let header = FakeHeaderViewModel()
        let footer = FakeFooterViewModel()
        let views = [FakeSupplementaryViewModel(), FakeSupplementaryViewModel(), FakeSupplementaryViewModel()]
        let section = SectionViewModel(
            id: "id",
            cells: cells1 + cells2,
            header: header,
            footer: footer,
            supplementaryViews: views
        )

        let allRegistrations = section.allRegistrations()
        XCTAssertEqual(allRegistrations.count, 5)

        XCTAssertTrue(allRegistrations.contains(FakeTextCellViewModel().registration))
        XCTAssertTrue(allRegistrations.contains(FakeNumberCellViewModel().registration))
        XCTAssertTrue(allRegistrations.contains(FakeHeaderViewModel().registration))
        XCTAssertTrue(allRegistrations.contains(FakeFooterViewModel().registration))
        XCTAssertTrue(allRegistrations.contains(FakeSupplementaryViewModel().registration))
    }

    func test_allSupplementaryViewsByIdentifier() {
        let cells = [FakeTextCellViewModel(), FakeTextCellViewModel(), FakeTextCellViewModel()]
        let originalViews = [FakeSupplementaryViewModel(), FakeSupplementaryViewModel(), FakeSupplementaryViewModel()]
        let section = SectionViewModel(id: "id", cells: cells, supplementaryViews: originalViews)

        let allViews = section.allSupplementaryViewsByIdentifier()
        XCTAssertEqual(allViews.count, 3)

        allViews.forEach { key, _ in
            let expected = originalViews.first { $0.id == key }
            XCTAssertEqual(allViews[key], expected?.eraseToAnyViewModel())
        }
    }

    func test_RandomAccessCollection_conformance() {
        let cells = [FakeTextCellViewModel(), FakeTextCellViewModel(), FakeTextCellViewModel()]
        let header = FakeHeaderViewModel()
        let footer = FakeFooterViewModel()
        let section = SectionViewModel(id: "id", cells: cells, header: header, footer: footer)

        XCTAssertEqual(section.count, section.cells.count)
        XCTAssertEqual(section.isEmpty, section.cells.isEmpty)
        XCTAssertEqual(section.startIndex, section.cells.startIndex)
        XCTAssertEqual(section.endIndex, section.cells.endIndex)
        XCTAssertEqual(section.index(after: 0), section.cells.index(after: 0))
        XCTAssertEqual(section[0], cells[0].eraseToAnyViewModel())
        XCTAssertEqual(section[1], cells[1].eraseToAnyViewModel())
        XCTAssertEqual(section[2], cells[2].eraseToAnyViewModel())
    }
}
