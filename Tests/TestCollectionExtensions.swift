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

final class TestCollectionExtensions: XCTestCase {
    func test_isNotEmpty() {
        XCTAssertTrue([1, 2, 3].isNotEmpty)
        XCTAssertFalse([].isNotEmpty)
    }
}
