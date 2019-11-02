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

protocol DiffableDataSourceProtocol {

    typealias Completion = () -> Void

    func apply(_ snapshot: DiffableSnapshot, animatingDifferences: Bool, completion: Completion?)

    func snapshot() -> DiffableSnapshot
}

func makeDiffableDataSource<View: UIView & CellContainerViewProtocol>(with view: View) -> DiffableDataSourceProtocol {
    switch view {
    case let table as UITableView:
        return TableDiffableDataSource(tableView: table)

    case let collection as UICollectionView:
        return CollectionDiffableDataSource(collectionView: collection)

    default:
        fatalError("Unsupported View type: \(view)")
    }
}

// MARK: CollectionDiffableDataSource

typealias CollectionDiffableDataSource = UICollectionViewDiffableDataSource<String, String>

extension CollectionDiffableDataSource: DiffableDataSourceProtocol {

    convenience init(collectionView: UICollectionView) {
        self.init(collectionView: collectionView) { _, _, _ -> UICollectionViewCell? in nil }
        self.supplementaryViewProvider = { _, _, _ -> UICollectionReusableView? in nil }
    }
}

// MARK: TableDiffableDataSource

typealias TableDiffableDataSource = UITableViewDiffableDataSource<String, String>

extension TableDiffableDataSource: DiffableDataSourceProtocol {

    convenience init(tableView: UITableView) {
        self.init(tableView: tableView) { _, _, _ -> UITableViewCell? in nil }
        self.defaultRowAnimation = .fade
    }
}

// MARK: DiffableSnapshot

typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<String, String>

extension DiffableSnapshot {

    init(model: ContainerViewModel) {
        self.init()

        let allSectionIdentifiers = model.sections.map { $0.id }
        self.appendSections(allSectionIdentifiers)

        model.sections.forEach {
            let allCellIdentifiers = $0.cellViewModels.map { $0.id }
            self.appendItems(allCellIdentifiers, toSection: $0.id)
        }
    }
}
