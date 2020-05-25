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

private struct FakeCustomViewHeaderModel: SupplementaryViewModel {
    let kind = SupplementaryViewKind.header

    var style: SupplementaryViewStyle {
        .customView(self.registration, self.config)
    }

    let registration = ReusableViewRegistration(classType: FakeCollectionHeaderView.self)

    var expectation: XCTestExpectation?
    var config: SupplementaryViewConfig {
        SupplementaryViewConfig { _ in
            self.expectation?.fulfill()
        }
    }
}

private struct FakeTitleFooterModel: SupplementaryViewModel {
    let kind = SupplementaryViewKind.footer
    let style = SupplementaryViewStyle.title("Footer Title")
}

final class TestSupplementaryViewModel: XCTestCase {

    func test_extensions_for_customView_based_model() {
        var customViewHeader = FakeCustomViewHeaderModel()

        XCTAssertTrue(customViewHeader._isCustomViewBased)
        XCTAssertFalse(customViewHeader._isTitleBased)

        XCTAssertEqual(customViewHeader._registration, customViewHeader.registration)

        customViewHeader.expectation = self.expectation()
        customViewHeader._apply(to: FakeCollectionHeaderView())
        self.waitForExpectations()
    }

    func test_extensions_for_title_based_model() {
        let titleFooter = FakeTitleFooterModel()

        XCTAssertTrue(titleFooter._isTitleBased)
        XCTAssertFalse(titleFooter._isCustomViewBased)

        XCTAssertEqual(titleFooter._title, "Footer Title")
    }
}
