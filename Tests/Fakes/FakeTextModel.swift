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

struct FakeTextModel: Hashable {
    let text: String

    init(text: String = .random) {
        self.text = text
    }
}

struct FakeTextCellViewModel: CellViewModel {
    let model: FakeTextModel

    nonisolated var id: UniqueIdentifier {
        self.model.text
    }

    var shouldHighlight = true

    var contextMenuConfiguration: UIContextMenuConfiguration?

    var expectationConfigureCell: XCTestExpectation?
    func configure(cell: FakeTextCollectionCell) {
        self.expectationConfigureCell?.fulfillAndLog()
    }

    var expectationDidSelect: XCTestExpectation?
    func didSelect(with coordinator: (any CellEventCoordinator)?) {
        self.expectationDidSelect?.fulfillAndLog()
    }

    var expectationWillDisplay: XCTestExpectation?
    func willDisplay() {
        self.expectationWillDisplay?.fulfillAndLog()
    }

    var expectationDidEndDisplaying: XCTestExpectation?
    func didEndDisplaying() {
        self.expectationDidEndDisplaying?.fulfillAndLog()
    }

    init(
        model: FakeTextModel = FakeTextModel(),
        shouldHighlight: Bool = true,
        contextMenuConfiguration: UIContextMenuConfiguration? = nil,
        expectationConfigureCell: XCTestExpectation? = nil,
        expectationDidSelect: XCTestExpectation? = nil
    ) {
        self.model = model
        self.shouldHighlight = shouldHighlight
        self.contextMenuConfiguration = contextMenuConfiguration
        self.expectationConfigureCell = expectationConfigureCell
        self.expectationDidSelect = expectationDidSelect
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.model == right.model
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(self.model)
    }
}

final class FakeTextCollectionCell: UICollectionViewCell { }
