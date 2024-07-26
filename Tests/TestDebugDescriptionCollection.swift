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

final class TestDebugDescriptionCollection: XCTestCase {

    @MainActor
    func test_empty() {
        let viewModel1 = generateCollectionWithKnownIds(
            id: "viewModel_1",
            numSections: 0,
            numCells: 0
        )
        XCTAssertEqual(
            viewModel1.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_1
              sections: none
              registrations: none
              isEmpty: true
            >

            """
        )
    }

    @MainActor
    func test_oneSection() {
        let viewModel4 = generateCollectionWithKnownIds(
            id: "viewModel_4",
            numSections: 1,
            numCells: 3
        )
        XCTAssertEqual(
            viewModel4.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_4
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel5 = generateCollectionWithKnownIds(
            id: "viewModel_5",
            numSections: 1,
            numCells: 3,
            useCellNibs: true
        )
        XCTAssertEqual(
            viewModel5.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_5
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeCellNibViewModel)
                    [1]: cell_1_section_0 (FakeCellNibViewModel)
                    [2]: cell_2_section_0 (FakeCellNibViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeCellNibViewModel (cell)
              isEmpty: false
            >

            """
        )
    }

    @MainActor
    func test_section_withHeaderFooter() {
        let viewModel6 = generateCollectionWithKnownIds(
            id: "viewModel_6",
            numSections: 1,
            numCells: 3,
            includeHeader: true
        )
        XCTAssertEqual(
            viewModel6.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_6
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel7 = generateCollectionWithKnownIds(
            id: "viewModel_7",
            numSections: 1,
            numCells: 3,
            includeFooter: true
        )
        XCTAssertEqual(
            viewModel7.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_7
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel8 = generateCollectionWithKnownIds(
            id: "viewModel_8",
            numSections: 1,
            numCells: 3,
            includeHeader: true,
            includeFooter: true
        )
        XCTAssertEqual(
            viewModel8.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_8
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )
    }

    @MainActor
    func test_section_withSupplementaryViews() {
        let viewModel9 = generateCollectionWithKnownIds(
            id: "viewModel_9",
            numSections: 1,
            numCells: 3,
            includeHeader: true,
            includeFooter: true,
            includeSupplementaryViews: true
        )
        XCTAssertEqual(
            viewModel9.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_9
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views:
                    [0]: supplementaryView_0_section_0 (FakeSupplementaryViewModel)
                    [1]: supplementaryView_1_section_0 (FakeSupplementaryViewModel)
                    [2]: supplementaryView_2_section_0 (FakeSupplementaryViewModel)
                  isEmpty: false
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

    @MainActor
    func test_multiple_sections() {
        let viewModel12 = generateCollectionWithKnownIds(
            id: "viewModel_12",
            numSections: 2,
            numCells: 3
        )
        XCTAssertEqual(
            viewModel12.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_12
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_1 (FakeNumberCellViewModel)
                    [1]: cell_1_section_1 (FakeTextCellViewModel)
                    [2]: cell_2_section_1 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel13 = generateCollectionWithKnownIds(
            id: "viewModel_13",
            numSections: 2,
            numCells: 3,
            useCellNibs: true
        )
        XCTAssertEqual(
            viewModel13.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_13
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeCellNibViewModel)
                    [1]: cell_1_section_0 (FakeCellNibViewModel)
                    [2]: cell_2_section_0 (FakeCellNibViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_1 (FakeCellNibViewModel)
                    [1]: cell_1_section_1 (FakeCellNibViewModel)
                    [2]: cell_2_section_1 (FakeCellNibViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeCellNibViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel14 = generateCollectionWithKnownIds(
            id: "viewModel_14",
            numSections: 2,
            numCells: 3,
            includeHeader: true
        )
        XCTAssertEqual(
            viewModel14.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_14
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: Header (FakeHeaderViewModel)
                  footer: nil
                  cells:
                    [0]: cell_0_section_1 (FakeNumberCellViewModel)
                    [1]: cell_1_section_1 (FakeTextCellViewModel)
                    [2]: cell_2_section_1 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )
    }

    @MainActor
    func test_multiple_sections_withSupplementaryViews() {
        let viewModel15 = generateCollectionWithKnownIds(
            id: "viewModel_15",
            numSections: 2,
            numCells: 3,
            includeFooter: true
        )
        XCTAssertEqual(
            viewModel15.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_15
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: nil
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_1 (FakeNumberCellViewModel)
                    [1]: cell_1_section_1 (FakeTextCellViewModel)
                    [2]: cell_2_section_1 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel16 = generateCollectionWithKnownIds(
            id: "viewModel_16",
            numSections: 2,
            numCells: 3,
            includeHeader: true,
            includeFooter: true
        )
        XCTAssertEqual(
            viewModel16.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_16
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_1 (FakeNumberCellViewModel)
                    [1]: cell_1_section_1 (FakeTextCellViewModel)
                    [2]: cell_2_section_1 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel17 = generateCollectionWithKnownIds(
            id: "viewModel_17",
            numSections: 2,
            numCells: 3,
            includeHeader: true,
            includeFooter: true,
            includeSupplementaryViews: true
        )
        XCTAssertEqual(
            viewModel17.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_17
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                    [2]: cell_2_section_0 (FakeNumberCellViewModel)
                  supplementary views:
                    [0]: supplementaryView_0_section_0 (FakeSupplementaryViewModel)
                    [1]: supplementaryView_1_section_0 (FakeSupplementaryViewModel)
                    [2]: supplementaryView_2_section_0 (FakeSupplementaryViewModel)
                  isEmpty: false
                [1]:
                  id: section_1
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_section_1 (FakeNumberCellViewModel)
                    [1]: cell_1_section_1 (FakeTextCellViewModel)
                    [2]: cell_2_section_1 (FakeNumberCellViewModel)
                  supplementary views:
                    [0]: supplementaryView_0_section_1 (FakeSupplementaryViewModel)
                    [1]: supplementaryView_1_section_1 (FakeSupplementaryViewModel)
                    [2]: supplementaryView_2_section_1 (FakeSupplementaryViewModel)
                  isEmpty: false
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

extension TestDebugDescriptionCollection {
    @MainActor
    func generateCollectionWithKnownIds(
        id: String,
        numSections: Int,
        numCells: Int,
        useCellNibs: Bool = false,
        includeHeader: Bool = false,
        includeFooter: Bool = false,
        includeSupplementaryViews: Bool = false
    ) -> CollectionViewModel {
        fakeCollectionViewModel(
            id: id,
            sectionId: { sectionIndex in "\(sectionIndex)" },
            cellId: { sectionIndex, cellIndex in "cell_\(cellIndex)_section_\(sectionIndex)" },
            supplementaryViewId: { sectionIndex, cellIndex in "supplementaryView_\(cellIndex)_section_\(sectionIndex)" },
            numSections: numSections,
            numCells: numCells,
            useCellNibs: useCellNibs,
            includeHeader: includeHeader,
            includeFooter: includeFooter,
            includeSupplementaryViews: includeSupplementaryViews
        )
    }
}
