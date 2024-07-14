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
    let number: Int
    let id: String

    init(
        number: Int = .random(in: 0...1_000_000),
        id: String = .random
    ) {
        self.number = number
        self.id = id
    }
}

struct FakeNumberCellViewModel: CellViewModel {
    let model: FakeNumberModel

    nonisolated var id: UniqueIdentifier {
        self.model.id
    }

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

    init(
        model: FakeNumberModel = FakeNumberModel(),
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

final class FakeNumberCollectionCell: UICollectionViewCell { }
