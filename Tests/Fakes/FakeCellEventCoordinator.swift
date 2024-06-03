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
    var expectationDidSelect: XCTestExpectation?
    func didSelectCell(viewModel: any CellViewModel) {
        self.expectationDidSelect?.fulfillAndLog()
    }
}
