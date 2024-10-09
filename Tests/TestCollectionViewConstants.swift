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
@testable import ReactiveCollectionsKit
import UIKit
import XCTest

final class TestCollectionViewConstants: XCTestCase {

    @MainActor
    func test_header() {
        XCTAssertEqual(CollectionViewConstants.headerKind, UICollectionView.elementKindSectionHeader)
    }

    @MainActor
    func test_footer() {
        XCTAssertEqual(CollectionViewConstants.footerKind, UICollectionView.elementKindSectionFooter)
    }
}
