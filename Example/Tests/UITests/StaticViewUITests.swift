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

final class StaticViewUITests: XCTestCase, @unchecked Sendable {
    @MainActor var app: XCUIApplication { XCUIApplication() }

    override func setUp() async throws {
        try await super.setUp()
        self.continueAfterFailure = false
        await self.app.launch()
        await self.app.activate()
    }

    @MainActor
    func test_view_other_tabs() {
        self.app.tabBars["Tab Bar"].buttons["Simple Static"].tap()
        self.app.collectionViews["Simple Static"].swipeUp()
        self.app.collectionViews["Simple Static"].swipeDown()

        self.app.tabBars["Tab Bar"].buttons["Flow Layout"].tap()
        self.app.collectionViews["Flow Layout"].swipeUp()
        self.app.collectionViews["Flow Layout"].swipeDown()
    }
}
