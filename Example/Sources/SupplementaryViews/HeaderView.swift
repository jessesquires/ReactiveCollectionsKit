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

enum HeaderViewStyle: Hashable {
    case large
    case small
}

struct HeaderViewModel: SupplementaryHeaderViewModel {
    let title: String
    let style: HeaderViewStyle

    // MARK: SupplementaryViewModel

    var id: UniqueIdentifier { self.title }

    func configure(view: UICollectionViewListCell) {
        var config: UIListContentConfiguration
        switch self.style {
        case .large:
            config = .prominentInsetGroupedHeader()

        case .small:
            config = .groupedHeader()
        }
        config.text = self.title
        view.contentConfiguration = config
    }

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.title)
        hasher.combine(self.style)
    }

    static func == (left: Self, right: Self) -> Bool {
        left.title == right.title
        && left.style == right.style
    }
}
