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

protocol DiffableDataSourceProtocol: AnyObject {

    typealias Completion = () -> Void

    func apply(_ snapshot: DiffableSnapshot, animatingDifferences: Bool, completion: Completion?)

    func snapshot() -> DiffableSnapshot
}

extension DiffableDataSourceProtocol {
    func apply(_ viewModel: ContainerViewModel, animated: Bool, completion: Completion?) {
        let snapshot = DiffableSnapshot(viewModel: viewModel)
        self.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
}

func makeDiffableDataSource<View: UIView & CellContainerViewProtocol>(with view: View) -> DiffableDataSourceProtocol {
    switch view {
    case let tableView as UITableView:
        return TableDiffableDataSource(view: tableView)

    case let collectionView as UICollectionView:
        return CollectionDiffableDataSource(view: collectionView)

    default:
        fatalError("Unsupported View type: \(view)")
    }
}

// MARK: CollectionDiffableDataSource

typealias CollectionDiffableDataSource = UICollectionViewDiffableDataSource<String, String>

extension CollectionDiffableDataSource: DiffableDataSourceProtocol {

    convenience init(view: UICollectionView) {
        self.init(collectionView: view) { _, _, _ -> UICollectionViewCell? in nil }
        self.supplementaryViewProvider = { _, _, _ -> UICollectionReusableView? in nil }
    }
}

// MARK: TableDiffableDataSource

typealias TableDiffableDataSource = UITableViewDiffableDataSource<String, String>

extension TableDiffableDataSource: DiffableDataSourceProtocol {

    convenience init(view: UITableView) {
        self.init(tableView: view) { _, _, _ -> UITableViewCell? in nil }
        self.defaultRowAnimation = .fade
    }
}

// MARK: DiffableSnapshot

typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<String, String>

extension DiffableSnapshot {

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
