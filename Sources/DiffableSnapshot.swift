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
    @MainActor
    init(viewModel: CollectionViewModel) {
        self.init()

        for section in viewModel.sections {
            self.appendSections([section.id])

            for cell in section {
                self.appendItems([cell.id], toSection: section.id)
            }
        }
    }
}
