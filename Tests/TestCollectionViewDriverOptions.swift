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

final class TestCollectionViewDriverOptions: XCTestCase {

    func test_defaultValues() {
        let options = CollectionViewDriverOptions()
        XCTAssertFalse(options.diffOnBackgroundQueue)
        XCTAssertFalse(options.reloadDataOnReplacingViewModel)
    }

    func test_debugDescription() {
        let options = CollectionViewDriverOptions()
        XCTAssertEqual(
            options.debugDescription,
            """
            CollectionViewDriverOptions {
              diffOnBackgroundQueue: false
              reloadDataOnReplacingViewModel: false
            }

            """
        )
    }
}
