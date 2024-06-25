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
        numSections: Int = Int.random(in: 2...15),
        numCells: Int = Int.random(in: 3...20),
        expectDidSelectCell: Bool = false,
        expectConfigureCell: Bool = false
    ) -> CollectionViewModel {
        let sections = (0..<numSections).map { _ in
            self.fakeSectionViewModel(
                numCells: numCells,
                expectDidSelectCell: expectDidSelectCell,
                expectConfigureCell: expectConfigureCell
            )
        }
        return CollectionViewModel(id: "collection_\(id)", sections: sections)
    }

    @MainActor
    func fakeSectionViewModel(
        id: String = .random,
        numCells: Int = Int.random(in: 1...20),
        includeHeader: Bool = false,
        includeFooter: Bool = false,
        expectDidSelectCell: Bool = false,
        expectConfigureCell: Bool = false
    ) -> SectionViewModel {
        let cells = self.fakeCellViewModels(
            count: numCells,
            expectDidSelectCell: expectDidSelectCell,
            expectConfigureCell: expectConfigureCell
        )
        let header = includeHeader ? FakeHeaderViewModel() : nil
        let footer = includeFooter ? FakeFooterViewModel() : nil
        return SectionViewModel(
            id: "section_\(id)",
            cells: cells,
            header: header,
            footer: footer
        )
    }

    @MainActor
    func fakeCellViewModels(
        count: Int = Int.random(in: 3...20),
        expectDidSelectCell: Bool = false,
        expectConfigureCell: Bool = false
    ) -> [AnyCellViewModel] {
        var cells = [AnyCellViewModel]()
        for index in 0..<count {
            let model = self._fakeCellViewModel(
                index: index,
                expectDidSelectCell: expectDidSelectCell,
                expectConfigureCell: expectConfigureCell
            )
            cells.append(model)
        }
        return cells
    }

    @MainActor
    private func _fakeCellViewModel(
        index: Int,
        expectDidSelectCell: Bool = false,
        expectConfigureCell: Bool = false
    ) -> AnyCellViewModel {
        if index.isMultiple(of: 2) {
            var viewModel = FakeNumberCellViewModel()
            viewModel.expectationDidSelect = self._cellDidSelectExpectation(expect: expectDidSelectCell, id: viewModel.id)
            viewModel.expectationConfigureCell = self._cellConfigureExpectation(expect: expectConfigureCell, id: viewModel.id)
            return viewModel.eraseToAnyViewModel()
        }

        if index.isMultiple(of: 3) {
            var viewModel = FakeCellNibViewModel()
            viewModel.expectationDidSelect = self._cellDidSelectExpectation(expect: expectDidSelectCell, id: viewModel.id)
            viewModel.expectationConfigureCell = self._cellConfigureExpectation(expect: expectConfigureCell, id: viewModel.id)
            return viewModel.eraseToAnyViewModel()
        }

        var viewModel = FakeTextCellViewModel()
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
