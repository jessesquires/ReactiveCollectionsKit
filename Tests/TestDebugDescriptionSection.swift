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

final class TestDebugDescriptionSection: XCTestCase {

    @MainActor
    func test_empty() {
        let viewModel1 = generateSectionWithKnownIds(
            id: "viewModel_1",
            numCells: 0
        )
        XCTAssertEqual(
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
    }

    @MainActor
    func test_oneCell() {
        let viewModel2 = generateSectionWithKnownIds(
            id: "viewModel_2",
            numCells: 1
        )
        XCTAssertEqual(
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
    }

    @MainActor
    func test_multipleCells() {
        let viewModel4 = generateSectionWithKnownIds(
            id: "viewModel_4",
            numCells: 3
        )
        XCTAssertEqual(
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

        let viewModel5 = generateSectionWithKnownIds(
            id: "viewModel_5",
            numCells: 3,
            useCellNibs: true
        )
        XCTAssertEqual(
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
    }

    @MainActor
    func test_multipleCells_withSupplementaryViews() {
        let viewModel6 = generateSectionWithKnownIds(
            id: "viewModel_6",
            numCells: 3,
            includeHeader: true
        )
        XCTAssertEqual(
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

        let viewModel7 = generateSectionWithKnownIds(
            id: "viewModel_7",
            numCells: 3,
            includeFooter: true
        )
        XCTAssertEqual(
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

        let viewModel8 = generateSectionWithKnownIds(
            id: "viewModel_8",
            numCells: 3,
            includeHeader: true,
            includeFooter: true
        )
        XCTAssertEqual(
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

        let viewModel9 = generateSectionWithKnownIds(
            id: "viewModel_9",
            numCells: 3,
            includeHeader: true,
            includeFooter: true,
            includeSupplementaryViews: true
        )
        XCTAssertEqual(
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
                [0]: supplementaryView_0 (FakeSupplementaryViewModel)
                [1]: supplementaryView_1 (FakeSupplementaryViewModel)
                [2]: supplementaryView_2 (FakeSupplementaryViewModel)
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

extension TestDebugDescriptionSection {
    @MainActor
    func generateSectionWithKnownIds(
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
            supplementaryViewId: { _, cellIndex in "supplementaryView_\(cellIndex)" },
            numCells: numCells,
            useCellNibs: useCellNibs,
            includeHeader: includeHeader,
            includeFooter: includeFooter,
            includeSupplementaryViews: includeSupplementaryViews
        )
    }
}
