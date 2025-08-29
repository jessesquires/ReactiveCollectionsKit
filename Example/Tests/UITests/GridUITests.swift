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

final class GridUITests: XCTestCase, @unchecked Sendable {
    @MainActor var app: XCUIApplication { XCUIApplication() }

    override func setUp() async throws {
        try await super.setUp()
        self.continueAfterFailure = false
        await self.app.launch()
        await self.app.activate()
    }

    @MainActor
    func test_grid_shuffle() {
        let shuffleButton = self.app.navigationBars["Grid"].buttons["repeat"]
        XCTAssertTrue(shuffleButton.waitForExistence(timeout: 3))

        for _ in 1...20 {
            shuffleButton.tap()
        }
    }

    @MainActor
    func test_grid_remove_reset() {
        let shuffleButton = self.app.navigationBars["Grid"].buttons["repeat"]
        XCTAssertTrue(shuffleButton.waitForExistence(timeout: 3))
        shuffleButton.tap()

        let resetButton = self.app.navigationBars["Grid"].buttons["Refresh"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 3))
        resetButton.tap()

        let collectionViewsQuery = self.app.collectionViews
        collectionViewsQuery.buttons["Remove All"].tap()

        resetButton.tap()
        collectionViewsQuery.buttons["Reset"].tap()
    }
}
