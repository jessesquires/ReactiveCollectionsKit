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

struct HeaderViewModel: SupplementaryViewModel {
    let title: String

    // MARK: SupplementaryViewModel

    var id: UniqueIdentifier { self.title }

    static let kind = UICollectionView.elementKindSectionHeader

    func configure(view: UICollectionViewListCell) {
        // TODO: custom for grid
        var config = UIListContentConfiguration.groupedHeader()
        config.text = self.title
        view.contentConfiguration = config
    }
}
