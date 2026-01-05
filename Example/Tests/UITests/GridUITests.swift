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

import XCTest

@MainActor
final class GridUITests: XCTestCase {
    var app: XCUIApplication { XCUIApplication() }

    override func setUp() async throws {
        try await super.setUp()
        self.continueAfterFailure = false
        self.app.launch()
        self.app.activate()
    }

    func test_grid_shuffle() {
        let shuffleButton = self.app.buttons["shuffle"].firstMatch
        XCTAssertTrue(shuffleButton.waitForExistence(timeout: 3))

        for _ in 1...20 {
            shuffleButton.tap()
        }
    }

    func test_grid_remove_reset() {
        let shuffleButton = self.app.buttons["shuffle"].firstMatch
        XCTAssertTrue(shuffleButton.waitForExistence(timeout: 3))
        shuffleButton.tap()

        let resetButton = self.app.buttons["Refresh"].firstMatch
        XCTAssertTrue(resetButton.waitForExistence(timeout: 3))
        resetButton.tap()

        let removeAllButton = self.app.buttons["Remove All"].firstMatch
        XCTAssertTrue(removeAllButton.waitForExistence(timeout: 3))
        removeAllButton.tap()

        XCTAssertTrue(resetButton.waitForExistence(timeout: 3))
        resetButton.tap()
    }
}
