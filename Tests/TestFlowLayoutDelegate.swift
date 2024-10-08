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
import XCTest

final class TestFlowLayoutDelegate: UnitTestCase, @unchecked Sendable {

    @MainActor
    func test_forwardsEvents_to_flowLayoutDelegate() {
        let model = self.fakeCollectionViewModel()
        let driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: model,
            options: .test()
        )

        let flowLayoutDelegate = FakeFlowLayoutDelegate()
        driver.flowLayoutDelegate = flowLayoutDelegate

        // Setup all expectations
        flowLayoutDelegate.expectationSizeForItem = self.expectation(name: "size_for_item")
        flowLayoutDelegate.expectationInsetForSection = self.expectation(name: "inset_for_section")
        flowLayoutDelegate.expectationMinimumLineSpacing = self.expectation(name: "line_spacing")
        flowLayoutDelegate.expectationMinimumInteritemSpacing = self.expectation(name: "inter_item_spacing")
        flowLayoutDelegate.expectationSizeForHeader = self.expectation(name: "size_for_header")
        flowLayoutDelegate.expectationSizeForFooter = self.expectation(name: "size_for_footer")

        // Call all delegate methods
        let collectionView = self.collectionView
        let layout = self.layout
        let indexPath = IndexPath(item: 0, section: 0)

        _ = driver.collectionView(collectionView, layout: layout, sizeForItemAt: indexPath)
        _ = driver.collectionView(collectionView, layout: layout, insetForSectionAt: 0)
        _ = driver.collectionView(collectionView, layout: layout, minimumLineSpacingForSectionAt: 0)
        _ = driver.collectionView(collectionView, layout: layout, minimumInteritemSpacingForSectionAt: 0)
        _ = driver.collectionView(collectionView, layout: layout, referenceSizeForHeaderInSection: 0)
        _ = driver.collectionView(collectionView, layout: layout, referenceSizeForFooterInSection: 0)

        // Verify expectations
        self.waitForExpectations()
    }

    @MainActor
    func test_delegateMethods_returnLayoutProperties_whenNoDelegateIsSet() {
        let model = self.fakeCollectionViewModel()
        let driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: model,
            options: .test()
        )

        self.layout.itemSize = CGSize(width: 100, height: 100)
        self.layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.layout.minimumLineSpacing = 42
        self.layout.minimumInteritemSpacing = 42
        self.layout.headerReferenceSize = CGSize(width: 400, height: 200)
        self.layout.footerReferenceSize = CGSize(width: 400, height: 100)

        let collectionView = self.collectionView
        let layout = collectionView.collectionViewLayout
        let indexPath = IndexPath(item: 0, section: 0)

        let size = driver.collectionView(collectionView, layout: layout, sizeForItemAt: indexPath)
        XCTAssertEqual(size, self.layout.itemSize)

        let inset = driver.collectionView(collectionView, layout: layout, insetForSectionAt: 0)
        XCTAssertEqual(inset, self.layout.sectionInset)

        let lineSpacing = driver.collectionView(collectionView, layout: layout, minimumLineSpacingForSectionAt: 0)
        XCTAssertEqual(lineSpacing, self.layout.minimumLineSpacing)

        let itemSpacing = driver.collectionView(collectionView, layout: layout, minimumInteritemSpacingForSectionAt: 0)
        XCTAssertEqual(itemSpacing, self.layout.minimumInteritemSpacing)

        let headerSize = driver.collectionView(collectionView, layout: layout, referenceSizeForHeaderInSection: 0)
        XCTAssertEqual(headerSize, self.layout.headerReferenceSize)

        let footerSize = driver.collectionView(collectionView, layout: layout, referenceSizeForFooterInSection: 0)
        XCTAssertEqual(footerSize, self.layout.footerReferenceSize)
    }
}
