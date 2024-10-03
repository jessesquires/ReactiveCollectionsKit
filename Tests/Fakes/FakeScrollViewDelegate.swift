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

final class FakeScrollViewDelegate: NSObject, UIScrollViewDelegate {

    var expectationDidScroll: XCTestExpectation?
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.expectationDidScroll?.fulfillAndLog()
    }

    var expectationWillBeginDrag: XCTestExpectation?
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.expectationWillBeginDrag?.fulfillAndLog()
    }

    var expectationWillEndDrag: XCTestExpectation?
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        self.expectationWillEndDrag?.fulfillAndLog()
    }

    var expectationDidEndDrag: XCTestExpectation?
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.expectationDidEndDrag?.fulfillAndLog()
    }

    var expectationShouldScrollToTop: XCTestExpectation?
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        self.expectationShouldScrollToTop?.fulfillAndLog()
        return true
    }

    var expectationDidScrollToTop: XCTestExpectation?
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.expectationDidScrollToTop?.fulfillAndLog()
    }

    var expectationWillBeginDecelerate: XCTestExpectation?
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.expectationWillBeginDecelerate?.fulfillAndLog()
    }

    var expectationDidEndDecelerate: XCTestExpectation?
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.expectationDidEndDecelerate?.fulfillAndLog()
    }

    var expectationViewForZoom: XCTestExpectation?
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.expectationViewForZoom?.fulfillAndLog()
        return nil
    }

    var expectationWillBeginZoom: XCTestExpectation?
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.expectationWillBeginZoom?.fulfillAndLog()
    }

    var expectationDidEndZoom: XCTestExpectation?
    func scrollViewDidEndZooming(_ scrollView: UIScrollView,
                                 with view: UIView?,
                                 atScale scale: CGFloat) {
        self.expectationDidEndZoom?.fulfillAndLog()
    }

    var expectationDidZoom: XCTestExpectation?
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.expectationDidZoom?.fulfillAndLog()
    }

    var expectationDidEndScrollAnimation: XCTestExpectation?
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.expectationDidEndScrollAnimation?.fulfillAndLog()
    }

    var expectationDidChangeInset: XCTestExpectation?
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.expectationDidChangeInset?.fulfillAndLog()
    }
}
