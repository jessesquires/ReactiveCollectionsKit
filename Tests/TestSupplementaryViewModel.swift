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

final class TestSupplementaryViewModel: XCTestCase {

    @MainActor
    func test_SupplementaryViewModel_protocol_extension() {
        let viewModel = FakeSupplementaryViewModel()
        XCTAssert(viewModel.viewClass == FakeSupplementaryView.self)
        XCTAssertEqual(viewModel.reuseIdentifier, "FakeSupplementaryViewModel")
    }

    @MainActor
    func test_eraseToAnyViewModel() {
        var viewModel = FakeSupplementaryViewModel()
        viewModel.expectationConfigureView = self.expectation(name: "configure_view")
        viewModel.expectationConfigureView?.expectedFulfillmentCount = 2

        let erased = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(viewModel.hashValue, erased.hashValue)

        XCTAssertEqual(erased.id, viewModel.id)
        XCTAssertEqual(erased.registration, viewModel.registration)

        // swiftlint:disable:next xct_specific_matcher
        XCTAssertTrue(erased.viewClass == viewModel.viewClass)
        XCTAssertEqual(erased.reuseIdentifier, viewModel.reuseIdentifier)

        viewModel.configure(view: FakeSupplementaryView())
        erased.configure(view: FakeSupplementaryView())
        self.waitForExpectations()

        let erased2 = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(erased, erased2)
        XCTAssertEqual(erased.hashValue, erased2.hashValue)

        XCTAssertNotEqual(erased, FakeSupplementaryViewModel().eraseToAnyViewModel())
        XCTAssertNotEqual(erased.hashValue, FakeSupplementaryViewModel().eraseToAnyViewModel().hashValue)

        let erased3 = viewModel.eraseToAnyViewModel().eraseToAnyViewModel()
        XCTAssertEqual(erased, erased3)
        XCTAssertEqual(erased.hashValue, erased3.hashValue)

        let erased4 = (viewModel.eraseToAnyViewModel() as (any SupplementaryViewModel)).eraseToAnyViewModel()
        XCTAssertEqual(erased, erased4)
        XCTAssertEqual(erased.hashValue, erased4.hashValue)

        let anyViewModel5 = AnySupplementaryViewModel(erased2)
        XCTAssertEqual(erased, anyViewModel5)
        XCTAssertEqual(erased.hashValue, anyViewModel5.hashValue)

        let anyViewModel6 = AnySupplementaryViewModel(erased3)
        XCTAssertEqual(erased, anyViewModel6)
        XCTAssertEqual(erased.hashValue, anyViewModel6.hashValue)

        let anyViewModel7 = AnySupplementaryViewModel(erased4)
        XCTAssertEqual(erased, anyViewModel7)
        XCTAssertEqual(erased.hashValue, anyViewModel7.hashValue)
    }

    @MainActor
    func test_header() {
        XCTAssertEqual(FakeHeaderViewModel.kind, UICollectionView.elementKindSectionHeader)

        let viewModel = FakeHeaderViewModel()
        XCTAssertEqual(viewModel._kind, UICollectionView.elementKindSectionHeader)

        let expected = ViewRegistration(
            reuseIdentifier: "FakeHeaderViewModel",
            supplementaryViewClass: FakeCollectionHeaderView.self,
            kind: UICollectionView.elementKindSectionHeader
        )
        XCTAssertEqual(viewModel.registration, expected)
    }

    @MainActor
    func test_footer() {
        XCTAssertEqual(FakeFooterViewModel.kind, UICollectionView.elementKindSectionFooter)

        let viewModel = FakeFooterViewModel()
        XCTAssertEqual(viewModel._kind, UICollectionView.elementKindSectionFooter)

        let expected = ViewRegistration(
            reuseIdentifier: "FakeFooterViewModel",
            supplementaryViewClass: FakeCollectionFooterView.self,
            kind: UICollectionView.elementKindSectionFooter
        )
        XCTAssertEqual(viewModel.registration, expected)
    }

    @MainActor
    func test_debugDescription() {
        let cell = FakeSupplementaryViewModel().eraseToAnyViewModel()
        print(cell.debugDescription)
    }
}
