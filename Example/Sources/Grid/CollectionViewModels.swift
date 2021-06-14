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

struct PersonCollectionCellViewModel: CellViewModel {
    let person: PersonModel
    let didSelect: CellActions.DidSelect

    var id: UniqueIdentifier { self.person.name }

    let registration = ReusableViewRegistration(classType: PersonCollectionCell.self,
                                                nibName: "CollectionCell",
                                                bundle: nil)

    func apply(to cell: UICollectionViewCell) {
        let cell = cell as! PersonCollectionCell
        cell.titleLabel.text = self.person.name
        cell.subtitleLabel.text = self.person.birthDateText
        cell.flagLabel.text = self.person.nationality
    }
}

struct ColorCollectionCellViewModel: CellViewModel {
    let color: ColorModel

    var id: UniqueIdentifier { "\(self.color.red)_\(self.color.green)_\(self.color.blue)" }

    let registration = ReusableViewRegistration(classType: UICollectionViewCell.self)

    let didSelect = CellActions.DidSelectNoOperation

    let shouldHighlight = false

    func apply(to cell: UICollectionViewCell) {
        cell.backgroundColor = self.color.uiColor
    }
}
