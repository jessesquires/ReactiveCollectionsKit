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
        let viewModel1 = self.fakeCollectionViewModel(
            id: "viewModel_1",
            numSections: 0,
            numCells: 0
        )
        XCTAssertEqual(
            viewModel1.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_1
              sections: none
              registrations: none
              isEmpty: true
            >

            """
        )
    }

    @MainActor
    func test_oneSection() {
        let viewModel4 = self.fakeCollectionViewModel(
            id: "viewModel_4",
            numSections: 1,
            numCells: 3
        )
        XCTAssertEqual(
            viewModel4.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_4
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel5 = self.fakeCollectionViewModel(
            id: "viewModel_5",
            numSections: 1,
            numCells: 3,
            useCellNibs: true
        )
        XCTAssertEqual(
            viewModel5.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_5
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_0 (FakeCellNibViewModel)
                    [1]: cell_0_1 (FakeCellNibViewModel)
                    [2]: cell_0_2 (FakeCellNibViewModel)
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
        let viewModel6 = self.fakeCollectionViewModel(
            id: "viewModel_6",
            numSections: 1,
            numCells: 3,
            includeHeader: true
        )
        XCTAssertEqual(
            viewModel6.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_6
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: nil
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
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

        let viewModel7 = self.fakeCollectionViewModel(
            id: "viewModel_7",
            numSections: 1,
            numCells: 3,
            includeFooter: true
        )
        XCTAssertEqual(
            viewModel7.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_7
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
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

        let viewModel8 = self.fakeCollectionViewModel(
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
              id: viewModel_8
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
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
        let viewModel9 = self.fakeCollectionViewModel(
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
              id: viewModel_9
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
                  supplementary views:
                    [0]: view_0_0 (FakeSupplementaryViewModel)
                    [1]: view_0_1 (FakeSupplementaryViewModel)
                    [2]: view_0_2 (FakeSupplementaryViewModel)
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
        let viewModel12 = self.fakeCollectionViewModel(
            id: "viewModel_12",
            numSections: 2,
            numCells: 3
        )
        XCTAssertEqual(
            viewModel12.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_12
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_1_0 (FakeNumberCellViewModel)
                    [1]: cell_1_1 (FakeTextCellViewModel)
                    [2]: cell_1_2 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeNumberCellViewModel (cell)
                - FakeTextCellViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel13 = self.fakeCollectionViewModel(
            id: "viewModel_13",
            numSections: 2,
            numCells: 3,
            useCellNibs: true
        )
        XCTAssertEqual(
            viewModel13.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_13
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_0_0 (FakeCellNibViewModel)
                    [1]: cell_0_1 (FakeCellNibViewModel)
                    [2]: cell_0_2 (FakeCellNibViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: nil
                  footer: nil
                  cells:
                    [0]: cell_1_0 (FakeCellNibViewModel)
                    [1]: cell_1_1 (FakeCellNibViewModel)
                    [2]: cell_1_2 (FakeCellNibViewModel)
                  supplementary views: none
                  isEmpty: false
              registrations:
                - FakeCellNibViewModel (cell)
              isEmpty: false
            >

            """
        )

        let viewModel14 = self.fakeCollectionViewModel(
            id: "viewModel_14",
            numSections: 2,
            numCells: 3,
            includeHeader: true
        )
        XCTAssertEqual(
            viewModel14.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_14
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: nil
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: Header (FakeHeaderViewModel)
                  footer: nil
                  cells:
                    [0]: cell_1_0 (FakeNumberCellViewModel)
                    [1]: cell_1_1 (FakeTextCellViewModel)
                    [2]: cell_1_2 (FakeNumberCellViewModel)
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
        let viewModel15 = self.fakeCollectionViewModel(
            id: "viewModel_15",
            numSections: 2,
            numCells: 3,
            includeFooter: true
        )
        XCTAssertEqual(
            viewModel15.debugDescription,
            """
            <CollectionViewModel:
              id: viewModel_15
              sections:
                [0]:
                  id: section_0
                  header: nil
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: nil
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_1_0 (FakeNumberCellViewModel)
                    [1]: cell_1_1 (FakeTextCellViewModel)
                    [2]: cell_1_2 (FakeNumberCellViewModel)
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

        let viewModel16 = self.fakeCollectionViewModel(
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
              id: viewModel_16
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
                  supplementary views: none
                  isEmpty: false
                [1]:
                  id: section_1
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_1_0 (FakeNumberCellViewModel)
                    [1]: cell_1_1 (FakeTextCellViewModel)
                    [2]: cell_1_2 (FakeNumberCellViewModel)
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

        let viewModel17 = self.fakeCollectionViewModel(
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
              id: viewModel_17
              sections:
                [0]:
                  id: section_0
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_0_0 (FakeNumberCellViewModel)
                    [1]: cell_0_1 (FakeTextCellViewModel)
                    [2]: cell_0_2 (FakeNumberCellViewModel)
                  supplementary views:
                    [0]: view_0_0 (FakeSupplementaryViewModel)
                    [1]: view_0_1 (FakeSupplementaryViewModel)
                    [2]: view_0_2 (FakeSupplementaryViewModel)
                  isEmpty: false
                [1]:
                  id: section_1
                  header: Header (FakeHeaderViewModel)
                  footer: Footer (FakeFooterViewModel)
                  cells:
                    [0]: cell_1_0 (FakeNumberCellViewModel)
                    [1]: cell_1_1 (FakeTextCellViewModel)
                    [2]: cell_1_2 (FakeNumberCellViewModel)
                  supplementary views:
                    [0]: view_1_0 (FakeSupplementaryViewModel)
                    [1]: view_1_1 (FakeSupplementaryViewModel)
                    [2]: view_1_2 (FakeSupplementaryViewModel)
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
