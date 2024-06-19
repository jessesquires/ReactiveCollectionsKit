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
        viewModel.expectationConfigureView = self.expectation(description: "configure-view")
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
}
