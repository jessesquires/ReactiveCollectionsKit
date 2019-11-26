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

private struct TestViewModel: CellViewModel {
    let registration = ReusableViewRegistration(classType: FakeTableCell.self)

    let didSelect = CellActions.DidSelectNoOperation

    func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize {
        .zero
    }

    func apply(to cell: Self.CellType) { }
}

final class TestCellViewModel: UnitTestCase {

    func test_CellViewModel_protocol_default_values() {
        let viewModel = TestViewModel()

        XCTAssertTrue(viewModel.shouldHighlight)
    }
}
