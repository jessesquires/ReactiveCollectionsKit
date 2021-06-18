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

struct PersonCellViewModel: CellViewModel {
    let person: PersonModel
    let didSelect: CellActions.DidSelect

    var id: UniqueIdentifier { self.person.name }

    let nib: UINib? = UINib(nibName: "CollectionCell", bundle: .main)

    func configure(cell: PersonCollectionCell, at indexPath: IndexPath) {
        cell.titleLabel.text = self.person.name
        cell.subtitleLabel.text = self.person.birthDateText
        cell.flagLabel.text = self.person.nationality
    }
}
