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

final class FakeCellNibView: UICollectionViewCell {
    @IBOutlet var label: UILabel!
}

struct FakeCellNibViewModel: CellViewModel {
    let id: UniqueIdentifier

    var registration: ViewRegistration {
        ViewRegistration(
            reuseIdentifier: self.reuseIdentifier,
            viewType: .cell,
            method: .nib(
                name: "FakeCellNib",
                bundle: .testBundle
            )
        )
    }

    var expectationConfigureCell: XCTestExpectation?
    func configure(cell: FakeCellNibView) {
        self.expectationConfigureCell?.fulfillAndLog()
    }

    var expectationDidSelect: XCTestExpectation?
    func didSelect(with coordinator: (any CellEventCoordinator)?) {
        self.expectationDidSelect?.fulfillAndLog()
    }

    var expectationDidDeselect: XCTestExpectation?
    func didDeelect(with coordinator: (any CellEventCoordinator)?) {
        self.expectationDidDeselect?.fulfillAndLog()
    }

    var expectationWillDisplay: XCTestExpectation?
    func willDisplay() {
        self.expectationWillDisplay?.fulfillAndLog()
    }

    var expectationDidEndDisplaying: XCTestExpectation?
    func didEndDisplaying() {
        self.expectationDidEndDisplaying?.fulfillAndLog()
    }

    var expectationDidHighlight: XCTestExpectation?
    func didHighlight() {
        self.expectationDidHighlight?.fulfillAndLog()
    }

    var expectationDidUnhighlight: XCTestExpectation?
    func didUnhighlight() {
        self.expectationDidUnhighlight?.fulfillAndLog()
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.id == right.id
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
