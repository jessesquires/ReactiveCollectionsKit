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

final class TestCellViewModel: XCTestCase {

    func test_CellViewModel_protocol_default_values() {
        let viewModel = TestCellModel()
        XCTAssertTrue(viewModel.shouldHighlight)
    }
}
