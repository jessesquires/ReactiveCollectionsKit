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
        let viewModel1 = fakeSectionViewModel(
            id: "viewModel_1",
            numCells: 0
        )
        XCTAssertEqual(
            viewModel1.debugDescription,
            """
            SectionViewModel {
              id: viewModel_1
              header: nil
              footer: nil
              cells: none
              supplementary views: none
              registrations: none
              isEmpty: true
            }
            """
        )
    }

    @MainActor
    func test_oneCell() {
        let viewModel2 = fakeSectionViewModel(
            id: "viewModel_2",
            numCells: 1
        )
        XCTAssertEqual(
            viewModel2.debugDescription,
            """
            SectionViewModel {
              id: viewModel_2
              header: nil
              footer: nil
              cells:
                [0]: cell_0_0 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - ReactiveCollectionsKitTests.FakeNumberCellViewModel (cell)
              isEmpty: false
            }
            """
        )
    }

    @MainActor
    func test_multipleCells() {
        let viewModel4 = fakeSectionViewModel(
            id: "viewModel_4",
            numCells: 3
        )
        XCTAssertEqual(
            viewModel4.debugDescription,
            """
            SectionViewModel {
              id: viewModel_4
              header: nil
              footer: nil
              cells:
                [0]: cell_0_0 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
                [1]: cell_0_1 (ReactiveCollectionsKitTests.FakeTextCellViewModel)
                [2]: cell_0_2 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - ReactiveCollectionsKitTests.FakeNumberCellViewModel (cell)
                - ReactiveCollectionsKitTests.FakeTextCellViewModel (cell)
              isEmpty: false
            }
            """
        )

        let viewModel5 = fakeSectionViewModel(
            id: "viewModel_5",
            numCells: 3,
            useCellNibs: true
        )
        XCTAssertEqual(
            viewModel5.debugDescription,
            """
            SectionViewModel {
              id: viewModel_5
              header: nil
              footer: nil
              cells:
                [0]: cell_0_0 (ReactiveCollectionsKitTests.FakeCellNibViewModel)
                [1]: cell_0_1 (ReactiveCollectionsKitTests.FakeCellNibViewModel)
                [2]: cell_0_2 (ReactiveCollectionsKitTests.FakeCellNibViewModel)
              supplementary views: none
              registrations:
                - ReactiveCollectionsKitTests.FakeCellNibViewModel (cell)
              isEmpty: false
            }
            """
        )
    }

    @MainActor
    func test_multipleCells_withSupplementaryViews() {
        let viewModel6 = fakeSectionViewModel(
            id: "viewModel_6",
            numCells: 3,
            includeHeader: true
        )
        XCTAssertEqual(
            viewModel6.debugDescription,
            """
            SectionViewModel {
              id: viewModel_6
              header: Header (ReactiveCollectionsKitTests.FakeHeaderViewModel)
              footer: nil
              cells:
                [0]: cell_0_0 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
                [1]: cell_0_1 (ReactiveCollectionsKitTests.FakeTextCellViewModel)
                [2]: cell_0_2 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - ReactiveCollectionsKitTests.FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - ReactiveCollectionsKitTests.FakeNumberCellViewModel (cell)
                - ReactiveCollectionsKitTests.FakeTextCellViewModel (cell)
              isEmpty: false
            }
            """
        )

        let viewModel7 = fakeSectionViewModel(
            id: "viewModel_7",
            numCells: 3,
            includeFooter: true
        )
        XCTAssertEqual(
            viewModel7.debugDescription,
            """
            SectionViewModel {
              id: viewModel_7
              header: nil
              footer: Footer (ReactiveCollectionsKitTests.FakeFooterViewModel)
              cells:
                [0]: cell_0_0 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
                [1]: cell_0_1 (ReactiveCollectionsKitTests.FakeTextCellViewModel)
                [2]: cell_0_2 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - ReactiveCollectionsKitTests.FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - ReactiveCollectionsKitTests.FakeNumberCellViewModel (cell)
                - ReactiveCollectionsKitTests.FakeTextCellViewModel (cell)
              isEmpty: false
            }
            """
        )

        let viewModel8 = fakeSectionViewModel(
            id: "viewModel_8",
            numCells: 3,
            includeHeader: true,
            includeFooter: true
        )
        XCTAssertEqual(
            viewModel8.debugDescription,
            """
            SectionViewModel {
              id: viewModel_8
              header: Header (ReactiveCollectionsKitTests.FakeHeaderViewModel)
              footer: Footer (ReactiveCollectionsKitTests.FakeFooterViewModel)
              cells:
                [0]: cell_0_0 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
                [1]: cell_0_1 (ReactiveCollectionsKitTests.FakeTextCellViewModel)
                [2]: cell_0_2 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
              supplementary views: none
              registrations:
                - ReactiveCollectionsKitTests.FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - ReactiveCollectionsKitTests.FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - ReactiveCollectionsKitTests.FakeNumberCellViewModel (cell)
                - ReactiveCollectionsKitTests.FakeTextCellViewModel (cell)
              isEmpty: false
            }
            """
        )

        let viewModel9 = fakeSectionViewModel(
            id: "viewModel_9",
            numCells: 3,
            includeHeader: true,
            includeFooter: true,
            includeSupplementaryViews: true
        )
        XCTAssertEqual(
            viewModel9.debugDescription,
            """
            SectionViewModel {
              id: viewModel_9
              header: Header (ReactiveCollectionsKitTests.FakeHeaderViewModel)
              footer: Footer (ReactiveCollectionsKitTests.FakeFooterViewModel)
              cells:
                [0]: cell_0_0 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
                [1]: cell_0_1 (ReactiveCollectionsKitTests.FakeTextCellViewModel)
                [2]: cell_0_2 (ReactiveCollectionsKitTests.FakeNumberCellViewModel)
              supplementary views:
                [0]: view_0_0 (ReactiveCollectionsKitTests.FakeSupplementaryViewModel)
                [1]: view_0_1 (ReactiveCollectionsKitTests.FakeSupplementaryViewModel)
                [2]: view_0_2 (ReactiveCollectionsKitTests.FakeSupplementaryViewModel)
              registrations:
                - ReactiveCollectionsKitTests.FakeFooterViewModel (UICollectionElementKindSectionFooter)
                - ReactiveCollectionsKitTests.FakeHeaderViewModel (UICollectionElementKindSectionHeader)
                - ReactiveCollectionsKitTests.FakeNumberCellViewModel (cell)
                - ReactiveCollectionsKitTests.FakeSupplementaryViewModel (FakeKind)
                - ReactiveCollectionsKitTests.FakeTextCellViewModel (cell)
              isEmpty: false
            }
            """
        )
    }
}
