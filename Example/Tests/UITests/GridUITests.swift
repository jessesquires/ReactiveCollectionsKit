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

final class GridUITests: XCTestCase {
    @MainActor var app: XCUIApplication { XCUIApplication() }

    @MainActor
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        self.app.launch()
    }

    @MainActor
    func test_grid_shuffle() {
        self.app.activate()

        let shuffleButton = self.app.navigationBars["Grid"].buttons["repeat"]

        for _ in 1...20 {
            shuffleButton.tap()
        }
    }

    @MainActor
    func test_grid_remove_reset() {
        self.app.activate()

        let shuffleButton = self.app.navigationBars["Grid"].buttons["repeat"]
        shuffleButton.tap()

        let resetButton = self.app.navigationBars["Grid"].buttons["Refresh"]
        resetButton.tap()

        let collectionViewsQuery = self.app.collectionViews
        collectionViewsQuery.buttons["Remove All"].tap()

        resetButton.tap()
        collectionViewsQuery.buttons["Reset"].tap()
    }
}
