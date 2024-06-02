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

final class TestCellEventCoordinator: XCTestCase {

    @MainActor
    func test_underlyingViewController() {
        class CustomVC: UIViewController, CellEventCoordinator { }
        let controller = CustomVC()
        XCTAssertEqual(controller.underlyingViewController, controller)

        let coordinator = FakeCellEventCoordinator()
        XCTAssertNil(coordinator.underlyingViewController)
    }
}
