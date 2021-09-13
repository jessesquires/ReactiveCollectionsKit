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

struct GridColorCellViewModel: CellViewModel {
    let color: ColorModel

    // MARK: CellViewModel

    var id: UniqueIdentifier { self.color.id }

    let shouldHighlight = false

    let contextMenuConfiguration: UIContextMenuConfiguration?

    func configure(cell: GridColorCell) {
        cell.label.text = self.color.name
        cell.backgroundColor = self.color.uiColor
    }
}
