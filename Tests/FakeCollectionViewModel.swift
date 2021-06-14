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

struct FakeCollectionCellViewModel: CellViewModel {
    static let defaultSize = CGSize(width: 50, height: 50)

    let text: String
    let didSelectExpectation: XCTestExpectation?
    let applyExpectation: XCTestExpectation?

    var didSelect: CellActions.DidSelect { { _, _, _ -> Void in
            self.didSelectExpectation?.fulfill()
        }
    }

    var id: UniqueIdentifier { self.text }

    let registration = ReusableViewRegistration(classType: FakeCollectionCell.self)

    func apply(to cell: Self.CellType) {
        self.applyExpectation?.fulfill()
    }
}

extension XCTestCase {
    func makeCollectionViewModel(numSections: Int = 3, numCells: Int = 5, includeExpectations: Bool = false) -> CollectionViewModel {
        let sections = (0..<numSections).map { _ in
            self.makeCollectionSectionViewModel(numCells: numCells, includeExpectations: includeExpectations)
        }
        return CollectionViewModel(sections: sections)
    }

    func makeCollectionSectionViewModel(name: String = .random, numCells: Int = 5, includeExpectations: Bool = false) -> SectionViewModel {
        let cellModels = (0..<numCells).map { _ in
            self.makeCollectionCellViewModel(includeExpectations: includeExpectations)
        }
        return SectionViewModel(id: "section_\(name)", cells: cellModels)
    }

    func makeCollectionCellViewModel(text: String = .random, includeExpectations: Bool = false) -> FakeCollectionCellViewModel {
        FakeCollectionCellViewModel(text: text,
                                    didSelectExpectation: includeExpectations ? self.expectation(description: "didSelect_\(text)") : nil,
                                    applyExpectation: includeExpectations ? self.expectation(description: "apply_\(text)"): nil)
    }
}

extension String {
    static var random: String {
        String(UUID().uuidString.dropLast(28))
    }
}
