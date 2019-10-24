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

struct PersonTableCellViewModel {
    let person: Person

    private static let _formatter: DateFormatter = {
        let fm = DateFormatter()
        fm.dateStyle = .medium
        fm.timeStyle = .none
        return fm
    }()

    private var _dateText: String {
        Self._formatter.string(from: self.person.birthdate)
    }
}

extension PersonTableCellViewModel: CellViewModel {

    var registration: ReusableViewRegistration {
        ReusableViewRegistration(classType: PersonTableCell.self)
    }

    func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize {
        CGSize(width: 0, height: 60)
    }

    func applyViewModelTo(cell: Self.CellType) {
        let cell = cell as! PersonTableCell
        cell.textLabel?.text = self.person.name
        cell.detailTextLabel?.text = "\(self.person.nationality) \(self._dateText)"
    }
}
