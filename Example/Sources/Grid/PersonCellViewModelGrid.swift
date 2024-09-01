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

struct PersonCellViewModelGrid: CellViewModel {
    let person: PersonModel

    // MARK: CellViewModel

    nonisolated var id: UniqueIdentifier { self.person.id }

    var registration: ViewRegistration {
        ViewRegistration(
            reuseIdentifier: self.reuseIdentifier,
            cellNibName: "GridPersonCell"
        )
    }

    let contextMenuConfiguration: UIContextMenuConfiguration?

    let shouldSelect: Bool

    func configure(cell: GridPersonCell) {
        cell.titleLabel.text = self.person.name
        cell.subtitleLabel.text = self.person.birthDateText
        cell.flagLabel.text = self.person.nationality
        cell.contentView.alpha = self.shouldSelect ? 1 : 0.3
    }

    // MARK: Hashable

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(self.person)
        hasher.combine(self.shouldSelect)
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.person == right.person
            && left.shouldSelect == right.shouldSelect
    }
}
