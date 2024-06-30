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
import XCTest

extension XCTestCase {
    var defaultTimeout: TimeInterval { 5 }

    @MainActor
    func waitForExpectations() {
        self.waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }

    func expectation(function: String = #function, name: String = "") -> XCTestExpectation {
        self.expectation(description: function + "-" + name)
    }
}
