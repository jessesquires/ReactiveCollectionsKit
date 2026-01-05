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
final class TestCollectionViewModel: XCTestCase {

    func test_emptyViewModel() {
        let viewModel = CollectionViewModel.empty

        XCTAssertTrue(viewModel.isEmpty)
        XCTAssertTrue(viewModel.sections.isEmpty)
    }

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

    func test_allSectionsByIdentifier() {
        let count = 3
        let section1 = self.fakeSectionViewModel(id: "1")
        let section2 = self.fakeSectionViewModel(id: "2")
        let section3 = self.fakeSectionViewModel(id: "3")
        let model = CollectionViewModel(id: "id", sections: [section1, section2, section3])
        let ids = model.sections.map(\.id)
        XCTAssertEqual(ids.count, count)

        let sectionsById = model.allSectionsByIdentifier()
        XCTAssertEqual(sectionsById.count, count)

        XCTAssertEqual(sectionsById[section1.id], section1)
        XCTAssertEqual(sectionsById[section2.id], section2)
        XCTAssertEqual(sectionsById[section3.id], section3)

        XCTAssertTrue(CollectionViewModel.empty.allSectionsByIdentifier().isEmpty)
    }

    func test_allCellsByIdentifier() {
        let model = self.fakeCollectionViewModel()
        let expectedIds = Set(model.sections.flatMap(\.cells).map(\.id))

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
}
