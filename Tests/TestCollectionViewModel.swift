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
    func test_debugDescription() {
        let viewModel = self.fakeCollectionViewModel()
        print(viewModel.debugDescription)
    }
}
