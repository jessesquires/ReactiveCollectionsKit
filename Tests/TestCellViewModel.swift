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
        viewModel.expectationConfigureCell = self.expectation(description: "configure-cell")
        viewModel.expectationDidSelect = self.expectation(description: "did-select")

        let erased = viewModel.eraseToAnyViewModel()

        XCTAssertEqual(erased.id, viewModel.id)
        XCTAssertEqual(erased.registration, viewModel.registration)
        XCTAssertEqual(erased.shouldHighlight, viewModel.shouldHighlight)
        XCTAssertIdentical(erased.contextMenuConfiguration, viewModel.contextMenuConfiguration)

        // swiftlint:disable:next xct_specific_matcher
        XCTAssertTrue(erased.cellClass == viewModel.cellClass)
        XCTAssertEqual(erased.reuseIdentifier, viewModel.reuseIdentifier)

        erased.configure(cell: FakeTextCollectionCell())
        erased.didSelect(with: nil)
        self.waitForExpectations()

        let erased2 = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(erased, erased2)

        XCTAssertNotEqual(erased, FakeCellViewModel().eraseToAnyViewModel())
    }
}
