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
        XCTAssertEqual(viewModel.reuseIdentifier, "ReactiveCollectionsKitTests.FakeSupplementaryViewModel")
    }

    // swiftlint:disable xct_specific_matcher
    @MainActor
    func test_eraseToAnyViewModel() {
        var viewModel = FakeSupplementaryViewModel()
        viewModel.expectationConfigureView = self.expectation(field: .configure, id: viewModel.id)
        viewModel.expectationConfigureView?.expectedFulfillmentCount = 2

        viewModel.expectationWillDisplay = self.expectation(field: .willDisplay, id: viewModel.id)
        viewModel.expectationWillDisplay?.expectedFulfillmentCount = 2

        viewModel.expectationDidEndDisplaying = self.expectation(field: .didEndDisplaying, id: viewModel.id)
        viewModel.expectationDidEndDisplaying?.expectedFulfillmentCount = 2

        let erased = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(erased.id, viewModel.id)
        XCTAssertEqual(erased.hashValue, viewModel.hashValue)
        XCTAssertEqual(erased.registration, viewModel.registration)
        XCTAssertTrue(erased.viewClass == viewModel.viewClass)
        XCTAssertEqual(erased.reuseIdentifier, viewModel.reuseIdentifier)

        viewModel.configure(view: FakeSupplementaryView())
        viewModel.willDisplay()
        viewModel.didEndDisplaying()

        erased.configure(view: FakeSupplementaryView())
        erased.willDisplay()
        erased.didEndDisplaying()

        self.waitForExpectations()

        let erased2 = viewModel.eraseToAnyViewModel()
        XCTAssertEqual(erased, erased2)
        XCTAssertEqual(erased.hashValue, erased2.hashValue)

        XCTAssertNotEqual(erased, FakeSupplementaryViewModel().eraseToAnyViewModel())
        XCTAssertNotEqual(erased.hashValue, FakeSupplementaryViewModel().eraseToAnyViewModel().hashValue)

        let erased3 = viewModel.eraseToAnyViewModel().eraseToAnyViewModel()
        XCTAssertEqual(erased3, erased)
        XCTAssertEqual(erased3.hashValue, erased.hashValue)
        XCTAssertEqual(erased3.id, viewModel.id)
        XCTAssertEqual(erased3.hashValue, viewModel.hashValue)
        XCTAssertEqual(erased3.registration, viewModel.registration)
        XCTAssertTrue(erased3.viewClass == viewModel.viewClass)
        XCTAssertEqual(erased3.reuseIdentifier, viewModel.reuseIdentifier)

        let erased4 = (viewModel.eraseToAnyViewModel() as (any SupplementaryViewModel)).eraseToAnyViewModel()
        XCTAssertEqual(erased4, erased)
        XCTAssertEqual(erased4.hashValue, erased.hashValue)
        XCTAssertEqual(erased4.id, viewModel.id)
        XCTAssertEqual(erased4.hashValue, viewModel.hashValue)
        XCTAssertEqual(erased4.registration, viewModel.registration)
        XCTAssertTrue(erased4.viewClass == viewModel.viewClass)
        XCTAssertEqual(erased4.reuseIdentifier, viewModel.reuseIdentifier)

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
    // swiftlint:enable xct_specific_matcher

    @MainActor
    func test_header() {
        XCTAssertEqual(FakeHeaderViewModel.kind, UICollectionView.elementKindSectionHeader)

        let viewModel = FakeHeaderViewModel()
        XCTAssertEqual(viewModel._kind, UICollectionView.elementKindSectionHeader)

        let expected = ViewRegistration(
            reuseIdentifier: "ReactiveCollectionsKitTests.FakeHeaderViewModel",
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
            reuseIdentifier: "ReactiveCollectionsKitTests.FakeFooterViewModel",
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
