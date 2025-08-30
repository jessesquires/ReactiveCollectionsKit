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

struct PersonCellViewModelList: CellViewModel {
    let person: PersonModel

    // MARK: CellViewModel

    var id: UniqueIdentifier { self.person.id }

    let contextMenuConfiguration: UIContextMenuConfiguration?

    let children: [AnyCellViewModel]

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
        var accessories = [flagEmoji, .disclosureIndicator(), .outlineDisclosure()]

        if self.person.isFavorite {
            let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
            imageView.tintColor = .systemYellow
            let favorite = UICellAccessory.customView(
                configuration: .init(customView: imageView, placement: .trailing())
            )
            accessories.append(favorite)
        }

        cell.accessories = accessories
    }

    func didSelect(with coordinator: (any CellEventCoordinator)?) {
        let personVC = PersonViewController(person: self.person)
        coordinator?.underlyingViewController?.navigationController?.pushViewController(personVC, animated: true)
    }

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.person)
    }

    static func == (left: Self, right: Self) -> Bool {
        left.person == right.person
    }
}
