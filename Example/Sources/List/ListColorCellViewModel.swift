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

struct ListColorCellViewModel: CellViewModel {
    let color: ColorModel

    // MARK: CellViewModel

    var id: UniqueIdentifier { self.color.name }

    let shouldHighlight = false

    func configure(cell: UICollectionViewListCell) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = self.color.name
        cell.contentConfiguration = contentConfiguration
        cell.backgroundView = UIView()
        cell.backgroundView?.backgroundColor = self.color.uiColor
    }
}
