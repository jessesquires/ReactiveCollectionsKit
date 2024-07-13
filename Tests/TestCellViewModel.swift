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
import XCTest

final class TestCellViewModel: XCTestCase {

    @MainActor
    func test_CellViewModel_protocol_default_values() {
        let viewModel = FakeCellViewModel()
        XCTAssertTrue(viewModel.shouldHighlight)
        XCTAssertNil(viewModel.contextMenuConfiguration)

        let coordinator = FakeCellEventCoordinator()
        coordinator.expectationDidSelect = self.expectation()
        viewModel.didSelect(with: coordinator)
        self.waitForExpectations()
    }

    @MainActor
    func test_CellViewModel_protocol_extension() {
        let viewModel = FakeCellViewModel()
        XCTAssert(viewModel.cellClass == FakeCollectionCell.self)
        XCTAssertEqual(viewModel.reuseIdentifier, "FakeCellViewModel")

        let expected = ViewRegistration(reuseIdentifier: "FakeCellViewModel", cellClass: FakeCollectionCell.self)
        XCTAssertEqual(viewModel.registration, expected)
    }

    @MainActor
    func test_eraseToAnyViewModel() {
        var viewModel = FakeTextCellViewModel()
        viewModel.expectationConfigureCell = self.expectation(name: "configure-cell")
        viewModel.expectationConfigureCell?.expectedFulfillmentCount = 2

        viewModel.expectationDidSelect = self.expectation(name: "did-select")
        viewModel.expectationDidSelect?.expectedFulfillmentCount = 2

        let erased = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(viewModel.hashValue, erased.hashValue)

        XCTAssertEqual(erased.id, viewModel.id)
        XCTAssertEqual(erased.registration, viewModel.registration)
        XCTAssertEqual(erased.shouldHighlight, viewModel.shouldHighlight)
        XCTAssertIdentical(erased.contextMenuConfiguration, viewModel.contextMenuConfiguration)

        // swiftlint:disable:next xct_specific_matcher
        XCTAssertTrue(erased.cellClass == viewModel.cellClass)
        XCTAssertEqual(erased.reuseIdentifier, viewModel.reuseIdentifier)

        viewModel.configure(cell: FakeTextCollectionCell())
        viewModel.didSelect(with: nil)

        erased.configure(cell: FakeTextCollectionCell())
        erased.didSelect(with: nil)

        self.waitForExpectations()

        let erased2 = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(erased, erased2)
        XCTAssertEqual(erased.hashValue, erased2.hashValue)

        XCTAssertNotEqual(erased, FakeCellViewModel().eraseToAnyViewModel())
        XCTAssertNotEqual(erased.hashValue, FakeCellViewModel().eraseToAnyViewModel().hashValue)

        let erased3 = viewModel.eraseToAnyViewModel().eraseToAnyViewModel()
        XCTAssertEqual(erased, erased3)
        XCTAssertEqual(erased.hashValue, erased3.hashValue)

        let erased4 = (viewModel.eraseToAnyViewModel() as (any CellViewModel)).eraseToAnyViewModel()
        XCTAssertEqual(erased, erased4)
        XCTAssertEqual(erased.hashValue, erased4.hashValue)

        let anyViewModel5 = AnyCellViewModel(erased2)
        XCTAssertEqual(erased, anyViewModel5)
        XCTAssertEqual(erased.hashValue, anyViewModel5.hashValue)

        let anyViewModel6 = AnyCellViewModel(erased3)
        XCTAssertEqual(erased, anyViewModel6)
        XCTAssertEqual(erased.hashValue, anyViewModel6.hashValue)

        let anyViewModel7 = AnyCellViewModel(erased4)
        XCTAssertEqual(erased, anyViewModel7)
        XCTAssertEqual(erased.hashValue, anyViewModel7.hashValue)
    }

    @MainActor
    func test_debugDescription() {
        let cell = FakeTextCellViewModel().eraseToAnyViewModel()
        print(cell.debugDescription)
    }
}
