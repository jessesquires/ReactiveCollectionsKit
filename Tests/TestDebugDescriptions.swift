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

final class TestDebugDescriptions: XCTestCase {

    @MainActor
    private func generateViewModel(
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
            supplementaryViewId: { sectionIndex, cellIndex in "supplementaryview_\(cellIndex)_section_\(sectionIndex)" },
            numSections: numSections,
            numCells: numCells,
            useCellNibs: useCellNibs,
            includeHeader: includeHeader,
            includeFooter: includeFooter,
            includeSupplementaryViews: includeSupplementaryViews
        )
    }

    @MainActor
    func test_collectionViewModel_debugDescription() {
        let viewModel1 = generateViewModel(
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

        let viewModel2 = generateViewModel(
            id: "viewModel_2",
            numSections: 1,
            numCells: 1
        )
        XCTAssertEqual(
            viewModel2.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_2
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeNumberCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel3 = generateViewModel(
            id: "viewModel_3",
            numSections: 1,
            numCells: 2
        )
        XCTAssertEqual(
            viewModel3.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_3
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel4 = generateViewModel(
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

        let viewModel5 = generateViewModel(
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

        let viewModel6 = generateViewModel(
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

        let viewModel7 = generateViewModel(
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

        let viewModel8 = generateViewModel(
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

        let viewModel9 = generateViewModel(
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
                    [0]: supplementaryview_0_section_0 (FakeSupplementaryViewModel)
                    [1]: supplementaryview_1_section_0 (FakeSupplementaryViewModel)
                    [2]: supplementaryview_2_section_0 (FakeSupplementaryViewModel)
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

        let viewModel10 = generateViewModel(
            id: "viewModel_10",
            numSections: 2,
            numCells: 1
        )
        XCTAssertEqual(
            viewModel10.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_10
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_1 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeNumberCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel11 = generateViewModel(
            id: "viewModel_11",
            numSections: 2,
            numCells: 2
        )
        XCTAssertEqual(
            viewModel11.debugDescription,
            """
            <CollectionViewModel:
              id: collection_viewModel_11
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_0 (FakeNumberCellViewModel)
                    [1]: cell_1_section_0 (FakeTextCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_section_1 (FakeNumberCellViewModel)
                    [1]: cell_1_section_1 (FakeTextCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel12 = generateViewModel(
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

        let viewModel13 = generateViewModel(
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

        let viewModel14 = generateViewModel(
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

        let viewModel15 = generateViewModel(
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

        let viewModel16 = generateViewModel(
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

        let viewModel17 = generateViewModel(
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
                    [0]: supplementaryview_0_section_0 (FakeSupplementaryViewModel)
                    [1]: supplementaryview_1_section_0 (FakeSupplementaryViewModel)
                    [2]: supplementaryview_2_section_0 (FakeSupplementaryViewModel)
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
                    [0]: supplementaryview_0_section_1 (FakeSupplementaryViewModel)
                    [1]: supplementaryview_1_section_1 (FakeSupplementaryViewModel)
                    [2]: supplementaryview_2_section_1 (FakeSupplementaryViewModel)
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
    func test_sectionViewModel_debugDescription() {
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

        let viewModel1 = viewModel(
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

        let viewModel2 = viewModel(
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

        let viewModel3 = viewModel(
            id: "viewModel_3",
            numCells: 2
        )
        XCTAssertEqual(
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

        let viewModel5 = viewModel(
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

        let viewModel6 = viewModel(
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

        let viewModel7 = viewModel(
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

        let viewModel8 = viewModel(
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

        let viewModel9 = viewModel(
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
