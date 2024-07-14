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

final class TestCollectionViewModel: XCTestCase {

    @MainActor
    func test_emptyViewModel() {
        let viewModel = CollectionViewModel.empty

        XCTAssertTrue(viewModel.isEmpty)
        XCTAssertTrue(viewModel.sections.isEmpty)
    }

    @MainActor
    func test_init_trims_empty_sections() {
        let sections = [
            SectionViewModel(id: "1"),
            SectionViewModel(id: "2"),
            SectionViewModel(id: "3", cells: self.fakeCellViewModels())
        ]
        let viewModel = CollectionViewModel(id: "id", sections: sections)

        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections.first?.id, "3")
    }

    @MainActor
    func test_sectionViewModel_forId() {
        let sections = [
            SectionViewModel(id: "first", cells: self.fakeCellViewModels()),
            SectionViewModel(id: "second", cells: self.fakeCellViewModels()),
            SectionViewModel(id: "third", cells: self.fakeCellViewModels())
        ]
        let viewModel = CollectionViewModel(id: "id", sections: sections)

        XCTAssertEqual(viewModel.sectionViewModel(for: "first"), sections[0])
        XCTAssertEqual(viewModel.sectionViewModel(for: "second"), sections[1])
        XCTAssertEqual(viewModel.sectionViewModel(for: "third"), sections[2])

        XCTAssertNil(viewModel.sectionViewModel(for: "nonexistent"))
    }

    @MainActor
    func test_sectionViewModel_atIndex() {
        let sections = [
            SectionViewModel(id: "first", cells: self.fakeCellViewModels()),
            SectionViewModel(id: "second", cells: self.fakeCellViewModels()),
            SectionViewModel(id: "third", cells: self.fakeCellViewModels())
        ]
        let viewModel = CollectionViewModel(id: "id", sections: sections)

        XCTAssertEqual(viewModel.sectionViewModel(at: 0), sections[0])
        XCTAssertEqual(viewModel.sectionViewModel(at: 1), sections[1])
        XCTAssertEqual(viewModel.sectionViewModel(at: 2), sections[2])
    }

    @MainActor
    func test_cellViewModel_forId() {
        let expectedCell = FakeCellViewModel()

        var cells = self.fakeCellViewModels()
        cells.append(expectedCell.eraseToAnyViewModel())
        let randomSection = SectionViewModel(id: "section", cells: cells.shuffled())

        let sections = [
            self.fakeSectionViewModel(),
            randomSection,
            self.fakeSectionViewModel()
        ].shuffled()

        let viewModel = CollectionViewModel(id: "id", sections: sections)

        XCTAssertEqual(viewModel.cellViewModel(for: expectedCell.id), expectedCell.eraseToAnyViewModel())

        XCTAssertNil(viewModel.cellViewModel(for: "nonexistent"))
    }

    @MainActor
    func test_cellViewModel_atIndexPath() {
        let expectedCell = FakeCellViewModel()
        let expectedSection = SectionViewModel(
            id: "section",
            cells: [
                FakeCellViewModel(), FakeCellViewModel(), expectedCell, FakeCellViewModel()
            ]
        )
        let sections = [
            self.fakeSectionViewModel(),
            expectedSection,
            self.fakeSectionViewModel()
        ]

        let viewModel = CollectionViewModel(id: "id", sections: sections)

        XCTAssertEqual(
            viewModel.cellViewModel(at: IndexPath(item: 2, section: 1)),
            expectedCell.eraseToAnyViewModel()
        )
    }

    @MainActor
    func test_supplementaryViewModel_forId() {
        let expected = FakeSupplementaryViewModel()

        let expectedSection = SectionViewModel(
            id: "section",
            cells: [FakeCellViewModel(), FakeCellViewModel(), FakeCellViewModel()],
            supplementaryViews: [FakeSupplementaryViewModel(), expected, FakeSupplementaryViewModel()].shuffled()
        )
        let sections = [
            self.fakeSectionViewModel(),
            expectedSection,
            self.fakeSectionViewModel()
        ]
        let viewModel = CollectionViewModel(id: "id", sections: sections)

        XCTAssertEqual(viewModel.supplementaryViewModel(for: expected.id), expected.eraseToAnyViewModel())

        XCTAssertNil(viewModel.supplementaryViewModel(for: "nonexistent"))
    }

    @MainActor
    func test_supplementaryViewModel_atIndexPath() {
        let expected = FakeSupplementaryViewModel()

        let expectedSection = SectionViewModel(
            id: "section",
            cells: [FakeCellViewModel(), FakeCellViewModel(), FakeCellViewModel()],
            supplementaryViews: [FakeSupplementaryViewModel(), expected, FakeSupplementaryViewModel()]
        )
        let sections = [
            self.fakeSectionViewModel(),
            expectedSection,
            self.fakeSectionViewModel()
        ]
        let viewModel = CollectionViewModel(id: "id", sections: sections)

        XCTAssertEqual(
            viewModel.supplementaryViewModel(
                ofKind: FakeSupplementaryViewModel.kind,
                at: IndexPath(item: 1, section: 1)
            ),
            expected.eraseToAnyViewModel()
        )
    }

    @MainActor
    func test_allRegistrations() {
        let cells = (1...3).map { _ in FakeNumberCellViewModel() }
        let header = FakeHeaderViewModel()
        let footer = FakeFooterViewModel()
        let views = (1...3).map { _ in FakeSupplementaryViewModel() }
        let section = SectionViewModel(
            id: "section",
            cells: cells,
            header: header,
            footer: footer,
            supplementaryViews: views
        )
        let model = CollectionViewModel(id: "id", sections: [section])

        let allRegistrations = model.allRegistrations()
        XCTAssertEqual(allRegistrations.count, 4)

        XCTAssertTrue(allRegistrations.contains(cells.first!.registration))
        XCTAssertTrue(allRegistrations.contains(header.registration))
        XCTAssertTrue(allRegistrations.contains(footer.registration))
        XCTAssertTrue(allRegistrations.contains(views.first!.registration))

        XCTAssertTrue(CollectionViewModel.empty.allRegistrations().isEmpty)
    }

    @MainActor
    func test_allSectionsByIdentifier() {
        let count = 3
        let section1 = self.fakeSectionViewModel(id: "1")
        let section2 = self.fakeSectionViewModel(id: "2")
        let section3 = self.fakeSectionViewModel(id: "3")
        let model = CollectionViewModel(id: "id", sections: [section1, section2, section3])
        let ids = model.sections.map { $0.id }
        XCTAssertEqual(ids.count, count)

        let sectionsById = model.allSectionsByIdentifier()
        XCTAssertEqual(sectionsById.count, count)

        XCTAssertEqual(sectionsById[section1.id], section1)
        XCTAssertEqual(sectionsById[section2.id], section2)
        XCTAssertEqual(sectionsById[section3.id], section3)

        XCTAssertTrue(CollectionViewModel.empty.allSectionsByIdentifier().isEmpty)
    }

    @MainActor
    func test_allCellsByIdentifier() {
        let model = self.fakeCollectionViewModel()
        let expectedIds = Set(model.sections.flatMap { $0.cells }.map { $0.id })

        let cellIds = Set(model.allCellsByIdentifier().keys)
        XCTAssertEqual(cellIds, expectedIds)

        XCTAssertTrue(CollectionViewModel.empty.allCellsByIdentifier().isEmpty)

        let cell1 = FakeNumberCellViewModel()
        let cell2 = FakeNumberCellViewModel()
        let cell3 = FakeNumberCellViewModel()
        let section = SectionViewModel(id: "section", cells: [cell1, cell2, cell3])
        let collection = CollectionViewModel(id: "id", sections: [section])
        let cellsById = collection.allCellsByIdentifier()
        XCTAssertEqual(cellsById[cell1.id], cell1.eraseToAnyViewModel())
        XCTAssertEqual(cellsById[cell2.id], cell2.eraseToAnyViewModel())
        XCTAssertEqual(cellsById[cell3.id], cell3.eraseToAnyViewModel())
    }

    @MainActor
    func test_RandomAccessCollection_conformance() {
        let sectionCount = Int.random(in: 5...15)
        let cellCount = Int.random(in: 5...10)
        let model = self.fakeCollectionViewModel(numSections: sectionCount, numCells: cellCount)

        XCTAssertEqual(model.count, model.sections.count)
        XCTAssertEqual(model.isEmpty, model.sections.isEmpty)
        XCTAssertEqual(model.startIndex, model.sections.startIndex)
        XCTAssertEqual(model.endIndex, model.sections.endIndex)
        XCTAssertEqual(model.index(after: 0), model.sections.index(after: 0))

        for index in 0..<sectionCount {
            XCTAssertEqual(model[index], model.sections[index])
        }
    }

    @MainActor
    func test_subscript_indexPath() {
        let cell1 = FakeNumberCellViewModel().eraseToAnyViewModel()
        let cell2 = FakeNumberCellViewModel().eraseToAnyViewModel()
        let cell3 = FakeNumberCellViewModel().eraseToAnyViewModel()
        let cells = [cell1, cell2, cell3]
        let section = SectionViewModel(id: "section", cells: cells)
        let model = CollectionViewModel(id: "id", sections: [section])

        XCTAssertEqual(model[IndexPath(item: 0, section: 0)], cell1)
        XCTAssertEqual(model[.init(item: 1, section: 0)], cell2)
        XCTAssertEqual(model[item: 2, section: 0], cell3)
    }

    @MainActor
    func test_debugDescription() {
        func viewModel(
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

        func assertEqual(
            _ lhs: String, _ rhs: String,
            _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line
        ) {
            XCTAssertEqual(lhs, rhs + "\n", message(), file: file, line: line)
        }

        let viewModel1 = viewModel(
            id: "viewModel_1",
            numSections: 0,
            numCells: 0
        )
        assertEqual(
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

        let viewModel2 = viewModel(
            id: "viewModel_2",
            numSections: 1,
            numCells: 1
        )
        assertEqual(
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

        let viewModel3 = viewModel(
            id: "viewModel_3",
            numSections: 1,
            numCells: 2
        )
        assertEqual(
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

        let viewModel4 = viewModel(
            id: "viewModel_4",
            numSections: 1,
            numCells: 3
        )
        assertEqual(
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

        let viewModel5 = viewModel(
            id: "viewModel_5",
            numSections: 1,
            numCells: 3,
            useCellNibs: true
        )
        assertEqual(
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

        let viewModel6 = viewModel(
            id: "viewModel_6",
            numSections: 1,
            numCells: 3,
            includeHeader: true
        )
        assertEqual(
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

        let viewModel7 = viewModel(
            id: "viewModel_7",
            numSections: 1,
            numCells: 3,
            includeFooter: true
        )
        assertEqual(
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

        let viewModel8 = viewModel(
            id: "viewModel_8",
            numSections: 1,
            numCells: 3,
            includeHeader: true,
            includeFooter: true
        )
        assertEqual(
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

        let viewModel9 = viewModel(
            id: "viewModel_9",
            numSections: 1,
            numCells: 3,
            includeHeader: true,
            includeFooter: true,
            includeSupplementaryViews: true
        )
        assertEqual(
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

        let viewModel10 = viewModel(
            id: "viewModel_10",
            numSections: 2,
            numCells: 1
        )
        assertEqual(
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

        let viewModel11 = viewModel(
            id: "viewModel_11",
            numSections: 2,
            numCells: 2
        )
        assertEqual(
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

        let viewModel12 = viewModel(
            id: "viewModel_12",
            numSections: 2,
            numCells: 3
        )
        assertEqual(
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

        let viewModel13 = viewModel(
            id: "viewModel_13",
            numSections: 2,
            numCells: 3,
            useCellNibs: true
        )
        assertEqual(
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

        let viewModel14 = viewModel(
            id: "viewModel_14",
            numSections: 2,
            numCells: 3,
            includeHeader: true
        )
        assertEqual(
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

        let viewModel15 = viewModel(
            id: "viewModel_15",
            numSections: 2,
            numCells: 3,
            includeFooter: true
        )
        assertEqual(
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

        let viewModel16 = viewModel(
            id: "viewModel_16",
            numSections: 2,
            numCells: 3,
            includeHeader: true,
            includeFooter: true
        )
        assertEqual(
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

        let viewModel17 = viewModel(
            id: "viewModel_17",
            numSections: 2,
            numCells: 3,
            includeHeader: true,
            includeFooter: true,
            includeSupplementaryViews: true
        )
        assertEqual(
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
}
