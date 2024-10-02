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
import ReactiveCollectionsKit
import UIKit
import XCTest

final class FakeCellEventCoordinator: CellEventCoordinator {
    var selectedCell: (any CellViewModel)?
    var expectationDidSelect: XCTestExpectation?
    func didSelectCell(viewModel: any CellViewModel) {
        self.selectedCell = viewModel
        self.expectationDidSelect?.fulfillAndLog()
    }

    var deselectedCell: (any CellViewModel)?
    var expectationDidDeselect: XCTestExpectation?
    func didDeselectCell(viewModel: any CellViewModel) {
        self.deselectedCell = viewModel
        self.expectationDidDeselect?.fulfillAndLog()
    }
}
