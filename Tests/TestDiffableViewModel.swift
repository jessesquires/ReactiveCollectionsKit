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

final class TestDiffableViewModel: XCTestCase {

    @MainActor
    func test_DiffableViewModel_protocol_default_values() {
        let viewModel = FakeCellViewModel()
        XCTAssertEqual(viewModel.id, "FakeCellViewModel")
    }
}
