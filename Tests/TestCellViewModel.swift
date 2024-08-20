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
        coordinator.expectationDidSelect = self.expectation(name: "did_select")
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

    // swiftlint:disable xct_specific_matcher
    @MainActor
    func test_eraseToAnyViewModel() {
        var viewModel = FakeTextCellViewModel()
        viewModel.expectationConfigureCell = self.expectation(field: .configure, id: viewModel.id)
        viewModel.expectationConfigureCell?.expectedFulfillmentCount = 2

        viewModel.expectationDidSelect = self.expectation(field: .didSelect, id: viewModel.id)
        viewModel.expectationDidSelect?.expectedFulfillmentCount = 2

        viewModel.expectationWillDisplay = self.expectation(field: .willDisplay, id: viewModel.id)
        viewModel.expectationWillDisplay?.expectedFulfillmentCount = 2

        viewModel.expectationDidEndDisplaying = self.expectation(field: .didEndDisplaying, id: viewModel.id)
        viewModel.expectationDidEndDisplaying?.expectedFulfillmentCount = 2

        viewModel.expectationDidHighlight = self.expectation(field: .didHighlight, id: viewModel.id)
        viewModel.expectationDidHighlight?.expectedFulfillmentCount = 2

        viewModel.expectationDidUnhighlight = self.expectation(field: .didUnhighlight, id: viewModel.id)
        viewModel.expectationDidUnhighlight?.expectedFulfillmentCount = 2

        let erased = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(viewModel.hashValue, erased.hashValue)

        XCTAssertEqual(erased.id, viewModel.id)
        XCTAssertEqual(erased.registration, viewModel.registration)
        XCTAssertEqual(erased.shouldHighlight, viewModel.shouldHighlight)
        XCTAssertIdentical(erased.contextMenuConfiguration, viewModel.contextMenuConfiguration)
        XCTAssertTrue(erased.cellClass == viewModel.cellClass)
        XCTAssertEqual(erased.reuseIdentifier, viewModel.reuseIdentifier)

        viewModel.configure(cell: FakeTextCollectionCell())
        viewModel.didSelect(with: nil)
        viewModel.willDisplay()
        viewModel.didEndDisplaying()
        viewModel.didHighlight()
        viewModel.didUnhighlight()

        erased.configure(cell: FakeTextCollectionCell())
        erased.didSelect(with: nil)
        erased.willDisplay()
        erased.didEndDisplaying()
        erased.didHighlight()
        erased.didUnhighlight()

        self.waitForExpectations()

        let erased2 = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(erased, erased2)
        XCTAssertEqual(erased.hashValue, erased2.hashValue)

        XCTAssertNotEqual(erased, FakeCellViewModel().eraseToAnyViewModel())
        XCTAssertNotEqual(erased.hashValue, FakeCellViewModel().eraseToAnyViewModel().hashValue)

        let erased3 = viewModel.eraseToAnyViewModel().eraseToAnyViewModel()
        XCTAssertEqual(erased3, erased)
        XCTAssertEqual(erased3.hashValue, erased.hashValue)

        XCTAssertEqual(erased3, viewModel.eraseToAnyViewModel())
        XCTAssertEqual(erased3.hashValue, viewModel.hashValue)
        XCTAssertEqual(erased3.id, viewModel.id)
        XCTAssertEqual(erased3.registration, viewModel.registration)
        XCTAssertEqual(erased3.shouldHighlight, viewModel.shouldHighlight)
        XCTAssertIdentical(erased3.contextMenuConfiguration, viewModel.contextMenuConfiguration)
        XCTAssertTrue(erased3.cellClass == viewModel.cellClass)
        XCTAssertEqual(erased3.reuseIdentifier, viewModel.reuseIdentifier)

        let erased4 = (viewModel.eraseToAnyViewModel() as (any CellViewModel)).eraseToAnyViewModel()
        XCTAssertEqual(erased4, erased)
        XCTAssertEqual(erased4.hashValue, erased.hashValue)

        XCTAssertEqual(erased4, viewModel.eraseToAnyViewModel())
        XCTAssertEqual(erased4.hashValue, viewModel.hashValue)
        XCTAssertEqual(erased4.id, viewModel.id)
        XCTAssertEqual(erased4.registration, viewModel.registration)
        XCTAssertEqual(erased4.shouldHighlight, viewModel.shouldHighlight)
        XCTAssertIdentical(erased4.contextMenuConfiguration, viewModel.contextMenuConfiguration)
        XCTAssertTrue(erased4.cellClass == viewModel.cellClass)
        XCTAssertEqual(erased4.reuseIdentifier, viewModel.reuseIdentifier)

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
    // swiftlint:enable xct_specific_matcher

    @MainActor
    func test_debugDescription() {
        let cell = FakeTextCellViewModel().eraseToAnyViewModel()
        print(cell.debugDescription)
    }
}
