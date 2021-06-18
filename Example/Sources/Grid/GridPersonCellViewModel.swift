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

struct GridPersonCellViewModel: CellViewModel {
    let person: PersonModel
    let didSelect: CellActions.DidSelect

    var id: UniqueIdentifier { self.person.name }

    let nib: UINib? = UINib(nibName: "GridPersonCell", bundle: .main)

    func configure(cell: GridPersonCell, at indexPath: IndexPath) {
        cell.titleLabel.text = self.person.name
        cell.subtitleLabel.text = self.person.birthDateText
        cell.flagLabel.text = self.person.nationality
    }
}
