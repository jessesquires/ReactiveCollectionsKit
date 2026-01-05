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

@MainActor
final class TestCollectionViewConstants: XCTestCase {

    func test_header() {
        XCTAssertEqual(CollectionViewConstants.headerKind, UICollectionView.elementKindSectionHeader)
    }

    func test_footer() {
        XCTAssertEqual(CollectionViewConstants.footerKind, UICollectionView.elementKindSectionFooter)
    }
}
