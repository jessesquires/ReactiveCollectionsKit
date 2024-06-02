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

struct TextModel: Hashable {
    let text = String.random
}

struct TextCellViewModel: CellViewModel {
    let model = TextModel()

    nonisolated var id: UniqueIdentifier {
        self.model.text
    }

    var shouldHighlight = true

    var contextMenuConfiguration: UIContextMenuConfiguration?

    var expectationConfigureCell: XCTestExpectation?
    func configure(cell: TextCollectionCell) {
        self.expectationConfigureCell?.fulfill()
    }

    var expectationDidSelect: XCTestExpectation?
    func didSelect(with coordinator: (any CellEventCoordinator)?) {
        self.expectationDidSelect?.fulfill()
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.model == right.model
    }

    nonisolated func hash(into hasher: inout Hasher) {
        self.model.hash(into: &hasher)
    }
}

final class TextCollectionCell: UICollectionViewCell { }
