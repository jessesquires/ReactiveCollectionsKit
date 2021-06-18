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

import UIKit

typealias _DiffableSnapshot = NSDiffableDataSourceSnapshot<String, String>

extension _DiffableSnapshot {

    init(viewModel: CollectionViewModel) {
        self.init()

        let allSectionIdentifiers = viewModel.sections.map { $0.id }
        self.appendSections(allSectionIdentifiers)

        viewModel.sections.forEach {
            let allCellIdentifiers = $0.cellViewModels.map { $0.id }
            self.appendItems(allCellIdentifiers, toSection: $0.id)
        }
    }
}
