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

final class TestSectionViewModel: XCTestCase {

    @MainActor
    func test_empty_section() {
        let section = SectionViewModel(id: "name")

        XCTAssertEqual(section.count, .zero)
        XCTAssertTrue(section.isEmpty)
    }

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

    @MainActor
    func test_cellViewModel_forId() {
        let cells = self.fakeCellViewModels(count: 10)
        let expected = cells.first!

        let section = SectionViewModel(id: "id", cells: cells.shuffled())

        XCTAssertEqual(section.cellViewModel(for: expected.id), expected)

        XCTAssertNil(section.cellViewModel(for: "nonexistent"))
    }

    @MainActor
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

    @MainActor
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

    @MainActor
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

    @MainActor
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

    @MainActor
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

    @MainActor
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

    @MainActor
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

    @MainActor
    func test_debugDescription() {
        func viewModel(
            id: String,
            numCells: Int,
            useCellNibs: Bool = false,
            includeHeader: Bool = false,
            includeFooter: Bool = false,
            includeSupplementaryViews: Bool = false
        ) -> SectionViewModel {
            fakeSectionViewModel(
                id: id,
                cellId: { _, cellIndex in "cell_\(cellIndex)" },
                supplementaryViewId: { _, cellIndex in "supplementaryview_\(cellIndex)" },
                numCells: numCells,
                useCellNibs: useCellNibs,
                includeHeader: includeHeader,
                includeFooter: includeFooter,
                includeSupplementaryViews: includeSupplementaryViews
            )
        }

        func assertEqual(
            _ lhs: String, _ rhs: String,
            _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line
        ) {
            XCTAssertEqual(lhs, rhs + "\n", message(), file: file, line: line)
        }

        let viewModel1 = viewModel(
            id: "viewModel_1",
            numCells: 0
        )
        assertEqual(
            viewModel1.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_1
              header: nil
              footer: nil
              cells: none
              supplementary views: none
              registrations: none
              isEmpty: true
            >
            """
        )

        let viewModel2 = viewModel(
            id: "viewModel_2",
            numCells: 1
        )
        assertEqual(
            viewModel2.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_2
              header: nil
              footer: nil
              cells:
                [0]: cell_0 (FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - FakeNumberCellViewModel (cell)
              isEmpty: false
            >
            """
        )

        let viewModel3 = viewModel(
            id: "viewModel_3",
            numCells: 2
        )
        assertEqual(
            viewModel3.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_3
              header: nil
              footer: nil
              cells:
                [0]: cell_0 (FakeNumberCellViewModel)
                [1]: cell_1 (FakeTextCellViewModel)
              supplementary views: none
              registrations:
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >
            """
        )

        let viewModel4 = viewModel(
            id: "viewModel_4",
            numCells: 3
        )
        assertEqual(
            viewModel4.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_4
              header: nil
              footer: nil
              cells:
                [0]: cell_0 (FakeNumberCellViewModel)
                [1]: cell_1 (FakeTextCellViewModel)
                [2]: cell_2 (FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >
            """
        )

        let viewModel5 = viewModel(
            id: "viewModel_5",
            numCells: 3,
            useCellNibs: true
        )
        assertEqual(
            viewModel5.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_5
              header: nil
              footer: nil
              cells:
                [0]: cell_0 (FakeCellNibViewModel)
                [1]: cell_1 (FakeCellNibViewModel)
                [2]: cell_2 (FakeCellNibViewModel)
              supplementary views: none
              registrations:
                - FakeCellNibViewModel (cell)
              isEmpty: false
            >
            """
        )

        let viewModel6 = viewModel(
            id: "viewModel_6",
            numCells: 3,
            includeHeader: true
        )
        assertEqual(
            viewModel6.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_6
              header: Header (FakeHeaderViewModel)
              footer: nil
              cells:
                [0]: cell_0 (FakeNumberCellViewModel)
                [1]: cell_1 (FakeTextCellViewModel)
                [2]: cell_2 (FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >
            """
        )

        let viewModel7 = viewModel(
            id: "viewModel_7",
            numCells: 3,
            includeFooter: true
        )
        assertEqual(
            viewModel7.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_7
              header: nil
              footer: Footer (FakeFooterViewModel)
              cells:
                [0]: cell_0 (FakeNumberCellViewModel)
                [1]: cell_1 (FakeTextCellViewModel)
                [2]: cell_2 (FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >
            """
        )

        let viewModel8 = viewModel(
            id: "viewModel_8",
            numCells: 3,
            includeHeader: true,
            includeFooter: true
        )
        assertEqual(
            viewModel8.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_8
              header: Header (FakeHeaderViewModel)
              footer: Footer (FakeFooterViewModel)
              cells:
                [0]: cell_0 (FakeNumberCellViewModel)
                [1]: cell_1 (FakeTextCellViewModel)
                [2]: cell_2 (FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >
            """
        )

        let viewModel9 = viewModel(
            id: "viewModel_9",
            numCells: 3,
            includeHeader: true,
            includeFooter: true,
            includeSupplementaryViews: true
        )
        assertEqual(
            viewModel9.debugDescription,
            """
            <SectionViewModel:
              id: section_viewModel_9
              header: Header (FakeHeaderViewModel)
              footer: Footer (FakeFooterViewModel)
              cells:
                [0]: cell_0 (FakeNumberCellViewModel)
                [1]: cell_1 (FakeTextCellViewModel)
                [2]: cell_2 (FakeNumberCellViewModel)
              supplementary views:
                [0]: supplementaryview_0 (FakeSupplementaryViewModel)
                [1]: supplementaryview_1 (FakeSupplementaryViewModel)
                [2]: supplementaryview_2 (FakeSupplementaryViewModel)
              registrations:
                - FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - FakeNumberCellViewModel (cell)
                - FakeSupplementaryViewModel (FakeKind)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >
            """
        )
    }
}
