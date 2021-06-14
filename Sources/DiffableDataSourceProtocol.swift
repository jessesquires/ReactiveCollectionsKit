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

typealias _CollectionDiffableDataSource = UICollectionViewDiffableDataSource<String, String>

extension _CollectionDiffableDataSource {
    typealias Completion = () -> Void

    convenience init(view: UICollectionView) {
        self.init(collectionView: view) { _, _, _ -> UICollectionViewCell? in nil }
        self.supplementaryViewProvider = { _, _, _ -> UICollectionReusableView? in nil }
    }

    func apply(_ viewModel: CollectionViewModel, animated: Bool, completion: Completion?) {
        let snapshot = _DiffableSnapshot(viewModel: viewModel)
        self.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
}

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
