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
        XCTAssertFalse(cell.isSupplementary)
        XCTAssertFalse(cell.isHeader)
        XCTAssertFalse(cell.isFooter)

        let view = ViewRegistrationViewType.supplementary(kind: "kind")
        XCTAssertFalse(view.isCell)
    }

    func test_isSupplementary() {
        let view = ViewRegistrationViewType.supplementary(kind: "kind")
        XCTAssertTrue(view.isSupplementary)
        XCTAssertFalse(view.isHeader)
        XCTAssertFalse(view.isFooter)
        XCTAssertFalse(view.isCell)

        let cell = ViewRegistrationViewType.cell
        XCTAssertFalse(cell.isSupplementary)
    }

    func test_isHeader() {
        let view = ViewRegistrationViewType.supplementary(kind: CollectionViewConstants.headerKind)

        XCTAssertTrue(view.isHeader)
        XCTAssertTrue(view.isSupplementary)

        XCTAssertFalse(view.isFooter)
        XCTAssertFalse(view.isCell)
    }

    func test_isFooter() {
        let view = ViewRegistrationViewType.supplementary(kind: CollectionViewConstants.footerKind)
        XCTAssertTrue(view.isFooter)
        XCTAssertTrue(view.isSupplementary)

        XCTAssertFalse(view.isHeader)
        XCTAssertFalse(view.isCell)
    }
}
