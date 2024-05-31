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

@testable import ReactiveCollectionsKit
import XCTest

final class TestEmptyViewProvider: XCTestCase {

    @MainActor
    func test_view() {
        let view = UILabel()
        view.text = "text"

        let provider = EmptyViewProvider {
            view
        }

        XCTAssertIdentical(provider.view, view)
    }
}
