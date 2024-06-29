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

final class TestViewRegistration: XCTestCase {

    private class TestView: UICollectionReusableView { }

    @MainActor
    func test_convenience_init_class_cell() {
        let id = "test"
        let registration = ViewRegistration(reuseIdentifier: id, cellClass: TestView.self)

        XCTAssertEqual(registration.reuseIdentifier, id)
        XCTAssertEqual(registration.viewType, .cell)
        XCTAssertEqual(registration.method, .viewClass(TestView.self))
    }

    @MainActor
    func test_convenience_init_nib_cell() {
        let id = "test"
        let nib = "nib"
        let registration = ViewRegistration(reuseIdentifier: id, cellNibName: nib)

        XCTAssertEqual(registration.reuseIdentifier, id)
        XCTAssertEqual(registration.viewType, .cell)
        XCTAssertEqual(registration.method, .nib(name: nib, bundle: nil))
    }

    @MainActor
    func test_convenience_init_class_supplementary() {
        let id = "test"
        let kind = "kind"
        let registration = ViewRegistration(reuseIdentifier: id, supplementaryViewClass: TestView.self, kind: kind)

        XCTAssertEqual(registration.reuseIdentifier, id)
        XCTAssertEqual(registration.viewType, .supplementary(kind: kind))
        XCTAssertEqual(registration.method, .viewClass(TestView.self))
    }

    @MainActor
    func test_convenience_init_nib_supplementary() {
        let id = "test"
        let nib = "nib"
        let kind = "kind"
        let registration = ViewRegistration(reuseIdentifier: id, supplementaryViewNibName: nib, kind: kind)

        XCTAssertEqual(registration.reuseIdentifier, id)
        XCTAssertEqual(registration.viewType, .supplementary(kind: kind))
        XCTAssertEqual(registration.method, .nib(name: nib, bundle: nil))
    }
}
