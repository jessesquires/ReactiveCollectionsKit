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

extension XCTestExpectation {
    func setInvertedAndLog() {
        self.isInverted = true
        print("Inverted expectation: \(self.expectationDescription)")
    }

    func fulfillAndLog() {
        self.fulfill()
        print("Fulfilled expectation: \(self.expectationDescription)")
    }
}
