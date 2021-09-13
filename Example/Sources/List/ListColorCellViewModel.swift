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

    var id: UniqueIdentifier { self.color.id }

    let shouldHighlight = false

    let contextMenuConfiguration: UIContextMenuConfiguration?

    func configure(cell: UICollectionViewListCell) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = self.color.name
        cell.contentConfiguration = contentConfiguration
        cell.backgroundView = UIView()
        cell.backgroundView?.backgroundColor = self.color.uiColor

        if self.color.isFavorite {
            let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
            imageView.tintColor = .label
            let favorite = UICellAccessory.customView(
                configuration: .init(customView: imageView, placement: .trailing())
            )
            cell.accessories = [favorite]
        } else {
            cell.accessories = []
        }
    }

    // MARK: Equatable

    public static func == (left: ListColorCellViewModel, right: ListColorCellViewModel) -> Bool {
        left.color == right.color
    }
}
