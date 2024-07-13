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

final class ListUITests: XCTestCase {
    @MainActor var app: XCUIApplication { XCUIApplication() }

    @MainActor
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        self.app.launch()
    }

    @MainActor
    func test_list_shuffle() {
        self.app.activate()

        self.app.tabBars["Tab Bar"].buttons["List"].tap()

        let shuffleButton = self.app.navigationBars["List"].buttons["repeat"]

        for _ in 1...20 {
            shuffleButton.tap()
        }
    }

    @MainActor
    func test_list_remove_reset() {
        self.app.activate()

        self.app.tabBars["Tab Bar"].buttons["List"].tap()

        let shuffleButton = self.app.navigationBars["List"].buttons["repeat"]
        shuffleButton.tap()

        let resetButton = self.app.navigationBars["List"].buttons["Refresh"]
        resetButton.tap()

        let collectionViewsQuery = self.app.collectionViews
        collectionViewsQuery.buttons["Remove All"].tap()

        resetButton.tap()
        collectionViewsQuery.buttons["Reset"].tap()
    }
}
