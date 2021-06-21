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

struct ListPersonCellViewModel: CellViewModel {
    let person: PersonModel

    // MARK: CellViewModel

    var id: UniqueIdentifier { self.person.name }

    func configure(cell: UICollectionViewListCell) {
        var contentConfiguration = UIListContentConfiguration.subtitleCell()
        contentConfiguration.text = self.person.name
        contentConfiguration.secondaryText = self.person.birthDateText
        contentConfiguration.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
        cell.contentConfiguration = contentConfiguration

        let label = UILabel()
        label.text = self.person.nationality
        let flagEmoji = UICellAccessory.customView(
            configuration: .init(customView: label, placement: .leading())
        )
        cell.accessories = [
            flagEmoji,
            .disclosureIndicator()
        ]
    }

    func didSelect(with controller: UIViewController) {
        let personVC = PersonViewController(person: self.person)
        controller.navigationController?.pushViewController(personVC, animated: true)
    }
}
