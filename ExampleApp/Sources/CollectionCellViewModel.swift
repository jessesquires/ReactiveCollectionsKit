//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit
import DiffableCollectionsKit

struct PersonCollectionCellViewModel {
    let person: Person

    private static let _formatter: DateFormatter = {
        let fm = DateFormatter()
        fm.dateStyle = .long
        fm.timeStyle = .none
        return fm
    }()

    private var _dateText: String {
        Self._formatter.string(from: self.person.birthdate)
    }
}

extension PersonCollectionCellViewModel: CellViewModel {
    var registration: ReusableViewRegistration {
        ReusableViewRegistration(classType: PersonCollectionCell.self, nibName: "CollectionCell", bundle: nil)
    }

    func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize {
        let collection = containerView as! UICollectionView
        return collection.uniformCellSize()
    }

    func applyViewModelTo(cell: Self.CellType) {
        let cell = cell as! PersonCollectionCell
        cell.titleLabel.text = self.person.name
        cell.subtitleLabel.text = self._dateText
        cell.flagLabel.text = self.person.nationality
    }
}
