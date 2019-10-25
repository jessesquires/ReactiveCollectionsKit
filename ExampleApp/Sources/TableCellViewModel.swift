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

struct PersonTableCellViewModel: CellViewModel {
    let person: Person

    let didSelect: CellActions.DidSelect

    let registration = ReusableViewRegistration(classType: PersonTableCell.self)

    func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize {
        CGSize(width: 0, height: 60)
    }

    func applyViewModelTo(cell: Self.CellType) {
        let cell = cell as! PersonTableCell
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.person.name
        cell.detailTextLabel?.text = "\(self.person.nationality) \(self.person.birthDateText)"
    }
}
