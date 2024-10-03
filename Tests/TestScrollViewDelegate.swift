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

final class TestScrollViewDelegate: UnitTestCase, @unchecked Sendable {

    @MainActor
    func test_forwardsEvents_to_scrollViewDelegate() {
        let model = self.fakeCollectionViewModel()
        let driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: model,
            options: .test()
        )

        let scrollViewDelegate = FakeScrollViewDelegate()
        driver.scrollViewDelegate = scrollViewDelegate

        // Setup all expectations
        scrollViewDelegate.expectationDidScroll = self.expectation(name: "did_scroll")
        scrollViewDelegate.expectationWillBeginDrag = self.expectation(name: "will_begin_drag")
        scrollViewDelegate.expectationWillEndDrag = self.expectation(name: "will_end_drag")
        scrollViewDelegate.expectationDidEndDrag = self.expectation(name: "did_end_drag")
        scrollViewDelegate.expectationShouldScrollToTop = self.expectation(name: "should_scroll_top")
        scrollViewDelegate.expectationDidScrollToTop = self.expectation(name: "did_scroll_top")
        scrollViewDelegate.expectationWillBeginDecelerate = self.expectation(name: "will_begin_decelerate")
        scrollViewDelegate.expectationDidEndDecelerate = self.expectation(name: "did_end_decelerate")
        scrollViewDelegate.expectationViewForZoom = self.expectation(name: "view_for_zoom")
        scrollViewDelegate.expectationWillBeginZoom = self.expectation(name: "will_begin_zoom")
        scrollViewDelegate.expectationDidEndZoom = self.expectation(name: "did_end_zoom")
        scrollViewDelegate.expectationDidZoom = self.expectation(name: "did_zoom")
        scrollViewDelegate.expectationDidEndScrollAnimation = self.expectation(name: "did_end_scroll_animation")
        scrollViewDelegate.expectationDidChangeInset = self.expectation(name: "did_change_inset")

        // Call all delegate methods
        let scrollView = self.collectionView
        driver.scrollViewDidScroll(scrollView)
        driver.scrollViewWillBeginDragging(scrollView)

        var offset = CGPoint.zero
        withUnsafeMutablePointer(to: &offset) { pointer in
            driver.scrollViewWillEndDragging(scrollView, withVelocity: .zero, targetContentOffset: pointer)
        }

        driver.scrollViewDidEndDragging(scrollView, willDecelerate: true)
        _ = driver.scrollViewShouldScrollToTop(scrollView)
        driver.scrollViewDidScrollToTop(scrollView)
        driver.scrollViewWillBeginDecelerating(scrollView)
        driver.scrollViewDidEndDecelerating(scrollView)
        _ = driver.viewForZooming(in: scrollView)
        driver.scrollViewWillBeginZooming(scrollView, with: nil)
        driver.scrollViewDidEndZooming(scrollView, with: nil, atScale: 1)
        driver.scrollViewDidZoom(scrollView)
        driver.scrollViewDidEndScrollingAnimation(scrollView)
        driver.scrollViewDidChangeAdjustedContentInset(scrollView)

        // Verify expectations
        self.waitForExpectations()

        self.keepDriverAlive(driver)
    }
}
