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

import ReactiveCollectionsKit
import UIKit

struct ColorCellViewModelGrid: CellViewModel {
    let color: ColorModel

    // MARK: CellViewModel

    nonisolated var id: UniqueIdentifier { self.color.id }

    let contextMenuConfiguration: UIContextMenuConfiguration?

    func configure(cell: GridColorCell) {
        cell.label.text = self.color.name
        cell.backgroundColor = self.color.uiColor
    }

    // MARK: Hashable

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(self.color)
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.color == right.color
    }
}
