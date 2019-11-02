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
    let person: Person
    let didSelect: CellActions.DidSelect

    var id: UniqueIdentifier { self.person.name }

    let registration = ReusableViewRegistration(classType: PersonCollectionCell.self,
                                                nibName: "CollectionCell",
                                                bundle: nil)

    func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize {
        let collection = containerView as! UICollectionView
        return collection.uniformCellSize()
    }

    func apply(to cell: Self.CellType) {
        let cell = cell as! PersonCollectionCell
        cell.titleLabel.text = self.person.name
        cell.subtitleLabel.text = self.person.birthDateText
        cell.flagLabel.text = self.person.nationality
    }
}
