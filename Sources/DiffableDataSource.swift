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

typealias _DiffableDataSource = UICollectionViewDiffableDataSource<String, String>

extension _DiffableDataSource {
    typealias Completion = () -> Void

    convenience init(view: UICollectionView, viewModel: CollectionViewModel) {
        self.init(collectionView: view) { collectionView, indexPath, _ in
            let cellViewModel = viewModel[indexPath]
            return cellViewModel.dequeueAndConfigureCellFor(collectionView: collectionView, at: indexPath)
        }
    }

    func apply(_ viewModel: CollectionViewModel, animated: Bool, completion: Completion?) {
        let snapshot = _DiffableSnapshot(viewModel: viewModel)
        self.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
}
