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
        var cellModels = [AnyCellViewModel]()
        for index in 0..<numCells {
            let model = self.fakeCellViewModel(
                index: index,
                expectDidSelectCell: expectDidSelectCell,
                expectConfigureCell: expectConfigureCell
            )
            cellModels.append(model)
        }
        let header = includeHeader ? FakeHeaderViewModel() : nil
        let footer = includeFooter ? FakeFooterViewModel() : nil
        return SectionViewModel(
            id: "section_\(id)",
            cells: cellModels,
            header: header,
            footer: footer
        )
    }

    @MainActor
    func fakeCellViewModel(
        index: Int,
        expectDidSelectCell: Bool = false,
        expectConfigureCell: Bool = false
    ) -> AnyCellViewModel {
        if index.isMultiple(of: 2) {
            var viewModel = FakeNumberCellViewModel()
            viewModel.expectationDidSelect = expectDidSelectCell ? self.expectation(description: "didSelect_\(viewModel.id)") : nil
            viewModel.expectationConfigureCell = expectConfigureCell ? self.expectation(description: "configureCell_\(viewModel.id)") : nil
            return viewModel.eraseToAnyViewModel()
        }

        var viewModel = FakeTextCellViewModel()
        viewModel.expectationDidSelect = expectDidSelectCell ? self.expectation(description: "didSelect_\(viewModel.id)") : nil
        viewModel.expectationConfigureCell = expectConfigureCell ? self.expectation(description: "configureCell_\(viewModel.id)") : nil
        return viewModel.eraseToAnyViewModel()

    }
}
