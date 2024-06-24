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

final class TestCollectionViewModel: XCTestCase {

    #warning("TODO: more tests")

    @MainActor
    func test_debugDescription() {
        let viewModel = self.fakeCollectionViewModel()
        print(viewModel.debugDescription)
    }
}
