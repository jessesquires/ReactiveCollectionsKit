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

struct FakeNumberModel: Hashable {
    let number = Int.random(in: 0...1_000_000)
    let id: String

    init(id: String = .random) {
        self.id = id
    }
}

struct FakeNumberCellViewModel: CellViewModel {
    let model: FakeNumberModel

    nonisolated var id: UniqueIdentifier {
        self.model.id
    }

    var shouldSelect = true

    var shouldDeselect = true

    var shouldHighlight = true

    var contextMenuConfiguration: UIContextMenuConfiguration?

    var expectationConfigureCell: XCTestExpectation?
    func configure(cell: FakeNumberCollectionCell) {
        self.expectationConfigureCell?.fulfillAndLog()
    }

    var expectationDidSelect: XCTestExpectation?
    func didSelect(with coordinator: (any CellEventCoordinator)?) {
        self.expectationDidSelect?.fulfillAndLog()
    }

    var expectationDidDeselect: XCTestExpectation?
    func didDeselect() {
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

    init(
        model: FakeNumberModel = FakeNumberModel(),
        shouldSelect: Bool = true,
        shouldDeselect: Bool = true,
        shouldHighlight: Bool = true,
        contextMenuConfiguration: UIContextMenuConfiguration? = nil
    ) {
        self.model = model
        self.shouldSelect = shouldSelect
        self.shouldDeselect = shouldDeselect
        self.shouldHighlight = shouldHighlight
        self.contextMenuConfiguration = contextMenuConfiguration
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.model == right.model
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(self.model)
    }
}

final class FakeNumberCollectionCell: UICollectionViewCell { }
