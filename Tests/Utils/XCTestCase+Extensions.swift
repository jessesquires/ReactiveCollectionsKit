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
import ReactiveCollectionsKit
import XCTest

extension XCTestCase {
    var defaultTimeout: TimeInterval { 5 }

    @MainActor
    func waitForExpectations() {
        self.waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }

    func expectation(function: String = #function, name: String? = nil) -> XCTestExpectation {
        self.expectation(description: [function, name].compactMap { $0 }.joined(separator: "-"))
    }

    func expectation(field: TestExpectationField, id: UniqueIdentifier, function: String = #function) -> XCTestExpectation {
        self.expectation(function: function, name: "\(field.rawValue)_\(id)")
    }
}
