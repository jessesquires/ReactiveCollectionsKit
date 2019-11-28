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

final class TestSupplementaryViewKind: XCTestCase {

    func test_initialization_from_collection_element_kind() {
        let header = SupplementaryViewKind(collectionElementKind: UICollectionView.elementKindSectionHeader)
        XCTAssertEqual(header, SupplementaryViewKind.header)
        XCTAssertEqual(header._collectionElementKind, UICollectionView.elementKindSectionHeader)

        let footer = SupplementaryViewKind(collectionElementKind: UICollectionView.elementKindSectionFooter)
        XCTAssertEqual(footer, SupplementaryViewKind.footer)
        XCTAssertEqual(footer._collectionElementKind, UICollectionView.elementKindSectionFooter)
    }
}
