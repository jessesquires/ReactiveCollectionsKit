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

struct ListPersonCellViewModel: CellViewModel {
    let person: PersonModel

    // MARK: CellViewModel

    let didSelect: CellActions.DidSelect

    var id: UniqueIdentifier { self.person.name }

    func configure(cell: UICollectionViewListCell, at indexPath: IndexPath) {
        var contentConfiguration = UIListContentConfiguration.subtitleCell()
        contentConfiguration.text = self.person.name
        contentConfiguration.secondaryText = self.person.birthDateText
        cell.contentConfiguration = contentConfiguration
    }
}
