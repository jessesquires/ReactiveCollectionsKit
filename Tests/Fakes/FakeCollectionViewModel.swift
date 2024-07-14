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
import UIKit
import XCTest

extension XCTestCase {
    @MainActor
    func fakeCollectionViewModel(
        id: String = .random,
        sectionId: (Int) -> String = { _ in .random },
        cellId: (Int, Int) -> String = { _, _ in .random },
        supplementaryViewId: (Int, Int) -> String = { _, _ in .random },
        numSections: Int = Int.random(in: 2...15),
        numCells: Int? = nil,
        useCellNibs: Bool = false,
        includeHeader: Bool = false,
        includeFooter: Bool = false,
        includeSupplementaryViews: Bool = false,
        expectDidSelectCell: Bool = false,
        expectConfigureCell: Bool = false
    ) -> CollectionViewModel {
        let sections = (0..<numSections).map { sectionIndex in
            self.fakeSectionViewModel(
                id: sectionId(sectionIndex),
                cellId: cellId,
                supplementaryViewId: supplementaryViewId,
                sectionIndex: sectionIndex,
                numCells: numCells ?? Int.random(in: 3...20),
                useCellNibs: useCellNibs,
                includeHeader: includeHeader,
                includeFooter: includeFooter,
                includeSupplementaryViews: includeSupplementaryViews,
                expectDidSelectCell: expectDidSelectCell,
                expectConfigureCell: expectConfigureCell
            )
        }
        return CollectionViewModel(id: "collection_\(id)", sections: sections)
    }

    @MainActor
    func fakeSectionViewModel(
        id: String = .random,
        cellId: (Int, Int) -> String = { _, _ in .random },
        supplementaryViewId: (Int, Int) -> String = { _, _ in .random },
        sectionIndex: Int = 0,
        numCells: Int = Int.random(in: 1...20),
        useCellNibs: Bool = false,
        includeHeader: Bool = false,
        includeFooter: Bool = false,
        includeSupplementaryViews: Bool = false,
        expectDidSelectCell: Bool = false,
        expectConfigureCell: Bool = false
    ) -> SectionViewModel {
        let cells = self.fakeCellViewModels(
            id: cellId,
            sectionIndex: sectionIndex,
            count: numCells,
            useNibs: useCellNibs,
            expectDidSelectCell: expectDidSelectCell,
            expectConfigureCell: expectConfigureCell
        )
        let header = includeHeader ? FakeHeaderViewModel() : nil
        let footer = includeFooter ? FakeFooterViewModel() : nil
        let supplementaryViews = includeSupplementaryViews
            ? (0..<numCells).map { cellIndex in FakeSupplementaryViewModel(title: supplementaryViewId(sectionIndex, cellIndex)) }
            : []
        return SectionViewModel(
            id: "section_\(id)",
            cells: cells,
            header: header,
            footer: footer,
            supplementaryViews: supplementaryViews
        )
    }

    @MainActor
    func fakeCellViewModels(
        id: (Int, Int) -> String = { _, _ in .random },
        sectionIndex: Int = 0,
        count: Int = Int.random(in: 3...20),
        useNibs: Bool = false,
        expectDidSelectCell: Bool = false,
        expectConfigureCell: Bool = false
    ) -> [AnyCellViewModel] {
        var cells = [AnyCellViewModel]()
        for cellIndex in 0..<count {
            let model = self._fakeCellViewModel(
                id: id(sectionIndex, cellIndex),
                cellIndex: cellIndex,
                useNibs: useNibs,
                expectDidSelectCell: expectDidSelectCell,
                expectConfigureCell: expectConfigureCell
            )
            cells.append(model)
        }
        return cells
    }

    @MainActor
    private func _fakeCellViewModel(
        id: String,
        cellIndex: Int,
        useNibs: Bool,
        expectDidSelectCell: Bool,
        expectConfigureCell: Bool
    ) -> AnyCellViewModel {
        if useNibs {
            var viewModel = FakeCellNibViewModel(id: id)
            viewModel.expectationDidSelect = self._cellDidSelectExpectation(expect: expectDidSelectCell, id: viewModel.id)
            viewModel.expectationConfigureCell = self._cellConfigureExpectation(expect: expectConfigureCell, id: viewModel.id)
            return viewModel.eraseToAnyViewModel()
        }

        if cellIndex.isMultiple(of: 2) {
            var viewModel = FakeNumberCellViewModel(model: .init(id: id))
            viewModel.expectationDidSelect = self._cellDidSelectExpectation(expect: expectDidSelectCell, id: viewModel.id)
            viewModel.expectationConfigureCell = self._cellConfigureExpectation(expect: expectConfigureCell, id: viewModel.id)
            return viewModel.eraseToAnyViewModel()
        }

        var viewModel = FakeTextCellViewModel(model: .init(text: id))
        viewModel.expectationDidSelect = self._cellDidSelectExpectation(expect: expectDidSelectCell, id: viewModel.id)
        viewModel.expectationConfigureCell = self._cellConfigureExpectation(expect: expectConfigureCell, id: viewModel.id)
        return viewModel.eraseToAnyViewModel()
    }

    @MainActor
    private func _cellDidSelectExpectation(expect: Bool, id: UniqueIdentifier) -> XCTestExpectation? {
        expect ? self.expectation(description: "didSelect_\(id)") : nil
    }

    @MainActor
    private func _cellConfigureExpectation(expect: Bool, id: UniqueIdentifier) -> XCTestExpectation? {
        expect ? self.expectation(description: "configureCell_\(id)") : nil
    }
}
