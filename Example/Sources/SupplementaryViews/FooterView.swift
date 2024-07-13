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

struct FooterViewModel: SupplementaryFooterViewModel {
    let text: String

    // MARK: SupplementaryViewModel

    nonisolated var id: UniqueIdentifier { self.text }

    func configure(view: UICollectionViewListCell) {
        var config = UIListContentConfiguration.groupedFooter()
        config.text = self.text
        view.contentConfiguration = config
    }
}
