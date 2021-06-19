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

    // MARK: CellViewModel

    var id: UniqueIdentifier { self.person.name }

    let nib: UINib? = UINib(nibName: "GridPersonCell", bundle: .main)

    func configure(cell: GridPersonCell) {
        cell.titleLabel.text = self.person.name
        cell.subtitleLabel.text = self.person.birthDateText
        cell.flagLabel.text = self.person.nationality
    }

    func didSelect(with controller: UIViewController) {
        let personVC = PersonViewController(person: self.person)
        controller.navigationController?.pushViewController(personVC, animated: true)
    }
}
