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
        expectationFields: Set<TestExpectationField> = [],
        function: String = #function
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
                expectationFields: expectationFields,
                function: function
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
        expectationFields: Set<TestExpectationField> = [],
        function: String = #function
    ) -> SectionViewModel {
        let cells = self.fakeCellViewModels(
            id: cellId,
            sectionIndex: sectionIndex,
            count: numCells,
            useNibs: useCellNibs,
            expectationFields: expectationFields,
            function: function
        )
        let header = includeHeader ? {
            var viewModel = FakeHeaderViewModel()
            viewModel.expectationConfigureView = self._expectation(expectationFields, target: .configure, id: viewModel.id, function: function)
            viewModel.expectationWillDisplay = self._expectation(expectationFields, target: .willDisplay, id: viewModel.id, function: function)
            viewModel.expectationDidEndDisplaying = self._expectation(expectationFields, target: .didEndDisplaying, id: viewModel.id, function: function)
            return viewModel
        }() : nil

        let footer = includeFooter ? {
            var viewModel = FakeFooterViewModel()
            viewModel.expectationConfigureView = self._expectation(expectationFields, target: .configure, id: viewModel.id, function: function)
            viewModel.expectationWillDisplay = self._expectation(expectationFields, target: .willDisplay, id: viewModel.id, function: function)
            viewModel.expectationDidEndDisplaying = self._expectation(expectationFields, target: .didEndDisplaying, id: viewModel.id, function: function)
            return viewModel
        }() : nil

        let supplementaryViews = includeSupplementaryViews
            ? (0..<numCells).map { cellIndex -> FakeSupplementaryViewModel in
                var viewModel = FakeSupplementaryViewModel(title: supplementaryViewId(sectionIndex, cellIndex))
                viewModel.expectationConfigureView = self._expectation(expectationFields, target: .configure, id: viewModel.id, function: function)
                viewModel.expectationWillDisplay = self._expectation(expectationFields, target: .willDisplay, id: viewModel.id, function: function)
                viewModel.expectationDidEndDisplaying = self._expectation(expectationFields, target: .didEndDisplaying, id: viewModel.id, function: function)
                return viewModel
            } : []

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
        expectationFields: Set<TestExpectationField> = [],
        function: String = #function
    ) -> [AnyCellViewModel] {
        var cells = [AnyCellViewModel]()
        for cellIndex in 0..<count {
            let model = self._fakeCellViewModel(
                id: id(sectionIndex, cellIndex),
                cellIndex: cellIndex,
                useNibs: useNibs,
                expectationFields: expectationFields,
                function: function
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
        expectationFields: Set<TestExpectationField>,
        function: String = #function
    ) -> AnyCellViewModel {
        if useNibs {
            var viewModel = FakeCellNibViewModel(id: id)
            viewModel.expectationDidSelect = self._expectation(expectationFields, target: .didSelect, id: viewModel.id, function: function)
            viewModel.expectationDidDeselect = self._expectation(expectationFields, target: .didDeselect, id: viewModel.id, function: function)
            viewModel.expectationConfigureCell = self._expectation(expectationFields, target: .configure, id: viewModel.id, function: function)
            viewModel.expectationWillDisplay = self._expectation(expectationFields, target: .willDisplay, id: viewModel.id, function: function)
            viewModel.expectationDidEndDisplaying = self._expectation(expectationFields, target: .didEndDisplaying, id: viewModel.id, function: function)
            viewModel.expectationDidHighlight = self._expectation(expectationFields, target: .didHighlight, id: viewModel.id, function: function)
            viewModel.expectationDidUnhighlight = self._expectation(expectationFields, target: .didUnhighlight, id: viewModel.id, function: function)
            return viewModel.eraseToAnyViewModel()
        }

        if cellIndex.isMultiple(of: 2) {
            var viewModel = FakeNumberCellViewModel(model: .init(id: id))
            viewModel.expectationDidSelect = self._expectation(expectationFields, target: .didSelect, id: viewModel.id, function: function)
            viewModel.expectationDidDeselect = self._expectation(expectationFields, target: .didDeselect, id: viewModel.id, function: function)
            viewModel.expectationConfigureCell = self._expectation(expectationFields, target: .configure, id: viewModel.id, function: function)
            viewModel.expectationWillDisplay = self._expectation(expectationFields, target: .willDisplay, id: viewModel.id, function: function)
            viewModel.expectationDidEndDisplaying = self._expectation(expectationFields, target: .didEndDisplaying, id: viewModel.id, function: function)
            viewModel.expectationDidHighlight = self._expectation(expectationFields, target: .didHighlight, id: viewModel.id, function: function)
            viewModel.expectationDidUnhighlight = self._expectation(expectationFields, target: .didUnhighlight, id: viewModel.id, function: function)
            return viewModel.eraseToAnyViewModel()
        }

        var viewModel = FakeTextCellViewModel(model: .init(text: id))
        viewModel.expectationDidSelect = self._expectation(expectationFields, target: .didSelect, id: viewModel.id, function: function)
        viewModel.expectationDidDeselect = self._expectation(expectationFields, target: .didDeselect, id: viewModel.id, function: function)
        viewModel.expectationConfigureCell = self._expectation(expectationFields, target: .configure, id: viewModel.id, function: function)
        viewModel.expectationWillDisplay = self._expectation(expectationFields, target: .willDisplay, id: viewModel.id, function: function)
        viewModel.expectationDidEndDisplaying = self._expectation(expectationFields, target: .didEndDisplaying, id: viewModel.id, function: function)
        viewModel.expectationDidHighlight = self._expectation(expectationFields, target: .didHighlight, id: viewModel.id, function: function)
        viewModel.expectationDidUnhighlight = self._expectation(expectationFields, target: .didUnhighlight, id: viewModel.id, function: function)
        return viewModel.eraseToAnyViewModel()
    }

    @MainActor
    private func _expectation(
        _ fields: Set<TestExpectationField>,
        target: TestExpectationField,
        id: UniqueIdentifier,
        function: String
    ) -> XCTestExpectation? {
        fields.contains(target) ? self.expectation(field: target, id: id, function: function) : nil
    }
}
