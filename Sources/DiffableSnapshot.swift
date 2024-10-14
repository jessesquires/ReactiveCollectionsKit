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

import Foundation
import UIKit

typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>

extension DiffableSnapshot {
    init(viewModel: CollectionViewModel) {
        self.init()

        let allSectionIdentifiers = viewModel.sections.map(\.id)
        self.appendSections(allSectionIdentifiers)

        viewModel.sections.forEach {
            let allCellIdentifiers = $0.cells.map(\.id)
            self.appendItems(allCellIdentifiers, toSection: $0.id)
        }
    }
}
