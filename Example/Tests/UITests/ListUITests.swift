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

final class ListUITests: XCTestCase, @unchecked Sendable {
    @MainActor var app: XCUIApplication { XCUIApplication() }

    override func setUp() async throws {
        try await super.setUp()
        self.continueAfterFailure = false
        await self.app.launch()
        await self.app.activate()
    }

    @MainActor
    func test_list_shuffle() {
        let listTab = self.app.images["list.dash"].firstMatch
        listTab.tap()

        let listView = self.app.staticTexts["List"].firstMatch
        XCTAssertTrue(listView.waitForExistence(timeout: 3))

        let shuffleButton = self.app.buttons["shuffle"].firstMatch
        XCTAssertTrue(shuffleButton.waitForExistence(timeout: 3))

        for _ in 1...20 {
            shuffleButton.tap()
        }
    }

    @MainActor
    func test_list_remove_reset() {
        let listTab = self.app.images["list.dash"].firstMatch
        listTab.tap()

        let listView = self.app.staticTexts["List"].firstMatch
        XCTAssertTrue(listView.waitForExistence(timeout: 3))

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
