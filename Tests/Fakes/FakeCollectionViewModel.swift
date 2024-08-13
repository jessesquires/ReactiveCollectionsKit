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

// swiftlint:disable function_parameter_count

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
        expectConfigureCell: Bool = false,
        expectWillDisplay: Bool = false,
        expectDidEndDisplaying: Bool = false,
        expectDidHighlight: Bool = false,
        expectDidUnhighlight: Bool = false
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
                expectConfigureCell: expectConfigureCell,
                expectWillDisplay: expectWillDisplay,
                expectDidEndDisplaying: expectDidEndDisplaying,
                expectDidHighlight: expectDidHighlight,
                expectDidUnhighlight: expectDidUnhighlight
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
        expectConfigureCell: Bool = false,
        expectWillDisplay: Bool = false,
        expectDidEndDisplaying: Bool = false,
        expectDidHighlight: Bool = false,
        expectDidUnhighlight: Bool = false
    ) -> SectionViewModel {
        let cells = self.fakeCellViewModels(
            id: cellId,
            sectionIndex: sectionIndex,
            count: numCells,
            useNibs: useCellNibs,
            expectDidSelectCell: expectDidSelectCell,
            expectConfigureCell: expectConfigureCell,
            expectWillDisplay: expectWillDisplay,
            expectDidEndDisplaying: expectDidEndDisplaying,
            expectDidHighlight: expectDidHighlight,
            expectDidUnhighlight: expectDidUnhighlight
        )
        var header = includeHeader ? FakeHeaderViewModel() : nil
        header?.expectationWillDisplay = self._willDisplayExpectation(expect: expectWillDisplay, id: "Header")
        header?.expectationDidEndDisplaying = self._didEndDisplayingExpectation(expect: expectDidEndDisplaying, id: "Header")
        var footer = includeFooter ? FakeFooterViewModel() : nil
        footer?.expectationWillDisplay = self._willDisplayExpectation(expect: expectWillDisplay, id: "Footer")
        footer?.expectationDidEndDisplaying = self._didEndDisplayingExpectation(expect: expectDidEndDisplaying, id: "Footer")
        let supplementaryViews = includeSupplementaryViews
            ? (0..<numCells).map { cellIndex -> FakeSupplementaryViewModel in
                var viewModel = FakeSupplementaryViewModel(title: supplementaryViewId(sectionIndex, cellIndex))
                viewModel.expectationWillDisplay = self._willDisplayExpectation(expect: expectWillDisplay, id: viewModel.id)
                viewModel.expectationDidEndDisplaying = self._didEndDisplayingExpectation(expect: expectDidEndDisplaying, id: viewModel.id)
                return viewModel
            }
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
        expectConfigureCell: Bool = false,
        expectWillDisplay: Bool = false,
        expectDidEndDisplaying: Bool = false,
        expectDidHighlight: Bool = false,
        expectDidUnhighlight: Bool = false
    ) -> [AnyCellViewModel] {
        var cells = [AnyCellViewModel]()
        for cellIndex in 0..<count {
            let model = self._fakeCellViewModel(
                id: id(sectionIndex, cellIndex),
                cellIndex: cellIndex,
                useNibs: useNibs,
                expectDidSelectCell: expectDidSelectCell,
                expectConfigureCell: expectConfigureCell,
                expectWillDisplay: expectWillDisplay,
                expectDidEndDisplaying: expectDidEndDisplaying,
                expectDidHighlight: expectDidHighlight,
                expectDidUnhighlight: expectDidUnhighlight
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
        expectConfigureCell: Bool,
        expectWillDisplay: Bool,
        expectDidEndDisplaying: Bool,
        expectDidHighlight: Bool,
        expectDidUnhighlight: Bool
    ) -> AnyCellViewModel {
        if useNibs {
            var viewModel = FakeCellNibViewModel(id: id)
            viewModel.expectationDidSelect = self._cellDidSelectExpectation(expect: expectDidSelectCell, id: viewModel.id)
            viewModel.expectationConfigureCell = self._cellConfigureExpectation(expect: expectConfigureCell, id: viewModel.id)
            viewModel.expectationWillDisplay = self._willDisplayExpectation(expect: expectWillDisplay, id: viewModel.id)
            viewModel.expectationDidEndDisplaying = self._didEndDisplayingExpectation(expect: expectDidEndDisplaying, id: viewModel.id)
            viewModel.expectationDidHighlight = self._didHighlightExpectation(expect: expectDidHighlight, id: viewModel.id)
            viewModel.expectationDidUnhighlight = self._didUnhighlightExpectation(expect: expectDidUnhighlight, id: viewModel.id)
            return viewModel.eraseToAnyViewModel()
        }

        if cellIndex.isMultiple(of: 2) {
            var viewModel = FakeNumberCellViewModel(model: .init(id: id))
            viewModel.expectationDidSelect = self._cellDidSelectExpectation(expect: expectDidSelectCell, id: viewModel.id)
            viewModel.expectationConfigureCell = self._cellConfigureExpectation(expect: expectConfigureCell, id: viewModel.id)
            viewModel.expectationWillDisplay = self._willDisplayExpectation(expect: expectWillDisplay, id: viewModel.id)
            viewModel.expectationDidEndDisplaying = self._didEndDisplayingExpectation(expect: expectDidEndDisplaying, id: viewModel.id)
            viewModel.expectationDidHighlight = self._didHighlightExpectation(expect: expectDidHighlight, id: viewModel.id)
            viewModel.expectationDidUnhighlight = self._didUnhighlightExpectation(expect: expectDidUnhighlight, id: viewModel.id)
            return viewModel.eraseToAnyViewModel()
        }

        var viewModel = FakeTextCellViewModel(model: .init(text: id))
        viewModel.expectationDidSelect = self._cellDidSelectExpectation(expect: expectDidSelectCell, id: viewModel.id)
        viewModel.expectationConfigureCell = self._cellConfigureExpectation(expect: expectConfigureCell, id: viewModel.id)
        viewModel.expectationWillDisplay = self._willDisplayExpectation(expect: expectWillDisplay, id: viewModel.id)
        viewModel.expectationDidEndDisplaying = self._didEndDisplayingExpectation(expect: expectDidEndDisplaying, id: viewModel.id)
        viewModel.expectationDidHighlight = self._didHighlightExpectation(expect: expectDidHighlight, id: viewModel.id)
        viewModel.expectationDidUnhighlight = self._didUnhighlightExpectation(expect: expectDidUnhighlight, id: viewModel.id)
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

    @MainActor
    private func _willDisplayExpectation(expect: Bool, id: UniqueIdentifier) -> XCTestExpectation? {
        expect ? self.expectation(description: "willDisplay_\(id)") : nil
    }

    @MainActor
    private func _didEndDisplayingExpectation(expect: Bool, id: UniqueIdentifier) -> XCTestExpectation? {
        expect ? self.expectation(description: "didEndDisplaying_\(id)") : nil
    }

    @MainActor
    private func _didHighlightExpectation(expect: Bool, id: UniqueIdentifier) -> XCTestExpectation? {
        expect ? self.expectation(description: "didHighlight_\(id)") : nil
    }

    @MainActor
    private func _didUnhighlightExpectation(expect: Bool, id: UniqueIdentifier) -> XCTestExpectation? {
        expect ? self.expectation(description: "didUnhighlight_\(id)") : nil
    }
}

// swiftlint:enable function_parameter_count
