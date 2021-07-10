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

    convenience init(view: UICollectionView, viewModel: CollectionViewModel) {
        self.init(collectionView: view) { collectionView, indexPath, _ in
            let cell = viewModel.cell(at: indexPath)
            return cell.dequeueAndConfigureCellFor(collectionView: collectionView, at: indexPath)
        }
        self.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            let supplementaryView = viewModel.supplementaryView(ofKind: elementKind, at: indexPath)
            return supplementaryView?.dequeueAndConfigureViewFor(collectionView: collectionView, at: indexPath)
        }
    }

    func apply(_ viewModel: CollectionViewModel, animated: Bool, completion: SnapshotCompletion?) {
        // TODO: compare current and new snapshot, derive moves and reload?
        let snapshot = _DiffableSnapshot(viewModel: viewModel)
        self.applySnapshot(snapshot, animated: animated, completion: completion)
    }

    func reload(_ viewModel: CollectionViewModel, completion: SnapshotCompletion?) {
        let snapshot = _DiffableSnapshot(viewModel: viewModel)
        self.reloadData(using: snapshot, completion: completion)
    }
}

extension UICollectionViewDiffableDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>

    typealias SnapshotCompletion = () -> Void

    func reloadData(using snapshot: Snapshot, completion: SnapshotCompletion? = nil) {
        if #available(iOS 15.0, *) {
            self.applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            self.apply(snapshot, animatingDifferences: false, completion: completion)
        }
    }

    func applySnapshot(_ snapshot: Snapshot, animated: Bool, completion: SnapshotCompletion? = nil) {
        if #available(iOS 15.0, *) {
            self.apply(snapshot, animatingDifferences: animated, completion: completion)
        } else {
            if animated {
                self.apply(snapshot, animatingDifferences: true, completion: completion)
            } else {
                UIView.performWithoutAnimation {
                    self.apply(snapshot, animatingDifferences: true, completion: completion)
                }
            }
        }
    }
}
