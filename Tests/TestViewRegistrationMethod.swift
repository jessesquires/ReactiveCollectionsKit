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

final class TestViewRegistrationMethod: XCTestCase {

    func test_nib_accessor() {
        let bundle = Bundle(for: Self.self)
        let method = ViewRegistrationMethod.fromNib(name: "FakeNib", bundle: bundle)
        XCTAssertNotNil(method._nib)
    }

    func test_equality() {
        let bundle = Bundle(for: Self.self)
        let method1 = ViewRegistrationMethod.fromNib(name: "FakeNib", bundle: bundle)
        XCTAssertEqual(method1, method1)

        let method2 = ViewRegistrationMethod.fromClass(FakeTableCell.self)
        XCTAssertNotEqual(method1, method2)

        let method3 = ViewRegistrationMethod.fromClass(FakeTableCell.self)
        XCTAssertEqual(method2, method3)

        let method4 = ViewRegistrationMethod.fromClass(FakeCollectionCell.self)
        XCTAssertNotEqual(method2, method4)
    }
}
