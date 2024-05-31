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

final class TestCollectionViewDriverOptions: XCTestCase {

    func test_defaultValues() {
        let options = CollectionViewDriverOptions()
        XCTAssertTrue(options.animateUpdates)
        XCTAssertFalse(options.diffOnBackgroundQueue)
        XCTAssertFalse(options.reloadDataOnReplacingViewModel)
    }
}
