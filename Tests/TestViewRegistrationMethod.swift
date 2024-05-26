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

    func test_viewClassName_nibName_nibBundle() {
        let method1 = ViewRegistrationMethod.viewClass(UICollectionViewListCell.self)

        XCTAssertEqual(method1._viewClassName, "UICollectionViewListCell")
        XCTAssertNil(method1._nibName)
        XCTAssertNil(method1._nibBundle)

        let method2 = ViewRegistrationMethod.nib(name: "name", bundle: .main)
        XCTAssertNil(method2._viewClassName)
        XCTAssertEqual(method2._nibName, "name")
        XCTAssertEqual(method2._nibBundle, .main)
    }

    func test_equatable_viewClass() {
        let method1 = ViewRegistrationMethod.viewClass(UICollectionViewListCell.self)
        let method2 = ViewRegistrationMethod.viewClass(UICollectionViewListCell.self)
        let method3 = ViewRegistrationMethod.viewClass(UIView.self)

        XCTAssertEqual(method1, method1)
        XCTAssertEqual(method1, method2)
        XCTAssertNotEqual(method1, method3)

        let set = Set([method1, method2, method3])
        XCTAssertEqual(set.count, 2)
        XCTAssertEqual(set, [method1, method3])
    }

    func test_equatable_nib() {
        let method1 = ViewRegistrationMethod.nib(name: "one", bundle: .main)
        let method2 = ViewRegistrationMethod.nib(name: "one", bundle: .main)
        let method3 = ViewRegistrationMethod.nib(name: "one", bundle: nil)
        let method4 = ViewRegistrationMethod.nib(name: "two", bundle: .main)
        let method5 = ViewRegistrationMethod.nib(name: "two", bundle: nil)
        let method6 = ViewRegistrationMethod.nib(name: "two", bundle: nil)

        XCTAssertEqual(method1, method1)
        XCTAssertEqual(method1, method2)
        XCTAssertNotEqual(method1, method3)
        XCTAssertNotEqual(method4, method5)
        XCTAssertEqual(method5, method6)

        let set = Set([method1, method2, method3, method4, method5, method6])
        XCTAssertEqual(set.count, 4)
        XCTAssertEqual(set, [method1, method3, method4, method5])
    }
}
