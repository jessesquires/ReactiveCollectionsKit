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

final class TestViewRegistrationViewType: XCTestCase {

    func test_kind() {
        let cell = ViewRegistrationViewType.cell
        XCTAssertEqual(cell.kind, "cell")

        let view = ViewRegistrationViewType.supplementary(kind: "kind")
        XCTAssertEqual(view.kind, "kind")
    }

    func test_isCell() {
        let cell = ViewRegistrationViewType.cell
        XCTAssertTrue(cell.isCell)

        let view = ViewRegistrationViewType.supplementary(kind: "kind")
        XCTAssertFalse(view.isCell)
    }

    func test_isSupplementary() {
        let cell = ViewRegistrationViewType.cell
        XCTAssertFalse(cell.isSupplementary)

        let view = ViewRegistrationViewType.supplementary(kind: "kind")
        XCTAssertTrue(view.isSupplementary)
    }
}
