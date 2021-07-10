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

typealias _DiffableDataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>

extension _DiffableDataSource {

    convenience init(view: UICollectionView) {
        self.init(collectionView: view) { _, _, _ in return nil }
    }

    convenience init(
        view: UICollectionView,
        cellProvider: @escaping _DiffableDataSource.CellProvider,
        supplementaryViewProvider: @escaping _DiffableDataSource.SupplementaryViewProvider
    ) {
        self.init(collectionView: view, cellProvider: cellProvider)
        self.supplementaryViewProvider = supplementaryViewProvider
    }

    func applySnapshot(
        from source: CollectionViewModel,
        to destination: CollectionViewModel,
        animated: Bool,
        completion: SnapshotCompletion?) {
        // TODO: compare current and new snapshot, derive item changes and reconfigure/reload?
        let destinationSnapshot = _DiffableSnapshot(viewModel: destination)
        self.applySnapshot(destinationSnapshot, animated: animated, completion: completion)
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
