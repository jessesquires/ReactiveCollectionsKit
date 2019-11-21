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

protocol _DiffableDataSourceProtocol: AnyObject {

    typealias Completion = () -> Void

    func apply(_ snapshot: _DiffableSnapshot, animatingDifferences: Bool, completion: Completion?)

    func snapshot() -> _DiffableSnapshot
}

extension _DiffableDataSourceProtocol {
    func apply(_ viewModel: ContainerViewModel, animated: Bool, completion: Completion?) {
        let snapshot = _DiffableSnapshot(viewModel: viewModel)
        self.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
}

func _makeDiffableDataSource<View: UIView & CellContainerViewProtocol>(with view: View) -> _DiffableDataSourceProtocol {
    switch view {
    case let tableView as UITableView:
        return _TableDiffableDataSource(view: tableView)

    case let collectionView as UICollectionView:
        return _CollectionDiffableDataSource(view: collectionView)

    default:
        fatalError("Unsupported View type: \(view)")
    }
}

// MARK: _CollectionDiffableDataSource

typealias _CollectionDiffableDataSource = UICollectionViewDiffableDataSource<String, String>

extension _CollectionDiffableDataSource: _DiffableDataSourceProtocol {

    convenience init(view: UICollectionView) {
        self.init(collectionView: view) { _, _, _ -> UICollectionViewCell? in nil }
        self.supplementaryViewProvider = { _, _, _ -> UICollectionReusableView? in nil }
    }
}

// MARK: _TableDiffableDataSource

typealias _TableDiffableDataSource = UITableViewDiffableDataSource<String, String>

extension _TableDiffableDataSource: _DiffableDataSourceProtocol {

    convenience init(view: UITableView) {
        self.init(tableView: view) { _, _, _ -> UITableViewCell? in nil }
        self.defaultRowAnimation = .fade
    }
}

// MARK: _DiffableSnapshot

typealias _DiffableSnapshot = NSDiffableDataSourceSnapshot<String, String>

extension _DiffableSnapshot {

    init(viewModel: ContainerViewModel) {
        self.init()

        let allSectionIdentifiers = viewModel.sections.map { $0.id }
        self.appendSections(allSectionIdentifiers)

        viewModel.sections.forEach {
            let allCellIdentifiers = $0.cellViewModels.map { $0.id }
            self.appendItems(allCellIdentifiers, toSection: $0.id)
        }
    }
}
