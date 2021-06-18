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

struct ColorCellViewModel: CellViewModel {
    let color: ColorModel

    var id: UniqueIdentifier { "\(self.color.red)_\(self.color.green)_\(self.color.blue)" }

    let didSelect = CellActions.DidSelectNoOperation

    let shouldHighlight = false

    func configure(cell: UICollectionViewListCell, at indexPath: IndexPath) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = "\(self.id)"
        cell.contentConfiguration = contentConfiguration
        cell.backgroundView = UIView()
        cell.backgroundView?.backgroundColor = self.color.uiColor
    }
}
