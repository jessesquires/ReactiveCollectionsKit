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
        numSections: Int = Int.random(in: 1...10),
        numCells: Int = Int.random(in: 1...10),
        includeExpectations: Bool = false
    ) -> CollectionViewModel {
        let sections = (0..<numSections).map { _ in
            self.fakeSectionViewModel(numCells: numCells, includeExpectations: includeExpectations)
        }
        return CollectionViewModel(id: "collection_\(id)", sections: sections)
    }

    @MainActor
    func fakeSectionViewModel(
        id: String = .random,
        numCells: Int = Int.random(in: 1...10),
        includeExpectations: Bool = false
    ) -> SectionViewModel {
        var cellModels = [AnyCellViewModel]()
        for index in 0..<numCells {
            let model = self.fakeCellViewModel(index: index, includeExpectations: includeExpectations)
            cellModels.append(model)
        }
        return SectionViewModel(id: "section_\(id)", cells: cellModels)
    }

    @MainActor
    func fakeCellViewModel(
        index: Int,
        includeExpectations: Bool = false
    ) -> AnyCellViewModel {
        if index.isMultiple(of: 2) {
            var viewModel = NumberCellViewModel()
            viewModel.expectationDidSelect = includeExpectations ? self.expectation(description: "didSelect_\(viewModel.id)") : nil
            viewModel.expectationConfigureCell = includeExpectations ? self.expectation(description: "apply_\(viewModel.id)") : nil
            return viewModel.eraseToAnyViewModel()
        }

        var viewModel = TextCellViewModel()
        viewModel.expectationDidSelect = includeExpectations ? self.expectation(description: "didSelect_\(viewModel.id)") : nil
        viewModel.expectationConfigureCell = includeExpectations ? self.expectation(description: "apply_\(viewModel.id)") : nil
        return viewModel.eraseToAnyViewModel()

    }
}
