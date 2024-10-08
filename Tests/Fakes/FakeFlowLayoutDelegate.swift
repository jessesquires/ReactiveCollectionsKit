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
import ReactiveCollectionsKit
import UIKit
import XCTest

final class FakeFlowLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {

    var expectationSizeForItem: XCTestExpectation?
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        self.expectationSizeForItem?.fulfillAndLog()
        return .zero
    }

    var expectationInsetForSection: XCTestExpectation?
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        self.expectationInsetForSection?.fulfillAndLog()
        return .zero
    }

    var expectationMinimumLineSpacing: XCTestExpectation?
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        self.expectationMinimumLineSpacing?.fulfillAndLog()
        return .zero
    }

    var expectationMinimumInteritemSpacing: XCTestExpectation?
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        self.expectationMinimumInteritemSpacing?.fulfillAndLog()
        return .zero
    }

    var expectationSizeForHeader: XCTestExpectation?
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        self.expectationSizeForHeader?.fulfillAndLog()
        return .zero
    }

    var expectationSizeForFooter: XCTestExpectation?
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        self.expectationSizeForFooter?.fulfillAndLog()
        return .zero
    }
}
