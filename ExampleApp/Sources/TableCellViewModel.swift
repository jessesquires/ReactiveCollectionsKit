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
    let registration = ReusableViewRegistration(classType: PersonTableCell.self)

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

    func applyViewModelTo(cell: Self.CellType) {
        let cell = cell as! PersonTableCell
        cell.textLabel?.text = self.person.name
        cell.detailTextLabel?.text = "\(self.person.nationality) \(self._dateText)"
    }
}
