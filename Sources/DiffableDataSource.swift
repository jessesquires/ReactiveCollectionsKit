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

typealias DiffableDataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>

extension DiffableDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>

    typealias SnapshotCompletion = () -> Void

    convenience init(view: UICollectionView) {
        self.init(collectionView: view) { _, _, _ in
            nil
        }
    }

    convenience init(
        view: UICollectionView,
        cellProvider: @escaping DiffableDataSource.CellProvider,
        supplementaryViewProvider: @escaping DiffableDataSource.SupplementaryViewProvider
    ) {
        self.init(collectionView: view, cellProvider: cellProvider)
        self.supplementaryViewProvider = supplementaryViewProvider
    }

    func applySnapshot(
        from source: CollectionViewModel,
        to destination: CollectionViewModel,
        animated: Bool,
        completion: SnapshotCompletion?) {
            // Build initial destination snapshot, then make adjustments (below)
            var destinationSnapshot = DiffableSnapshot(viewModel: destination)

            // Apply item updates, then section updates.
            // Reloading a section is required to properly reload headers, footers, and other supplementary views.
            // This 2-step process is necessary to preserve collection view animations
            // and prevent data source internal inconsistency exceptions.
            //
            // If we only reloaded a section, there are 2 problems:
            // 1. item updates would not animate correctly. (because the whole section is reloaded)
            // 2. item inserts/deletes could trigger an internal inconsistency exception in the data source.

            // Find and perform item (cell) updates first
            let allSourceCells = source.allCellsByIdentifier
            let allDestinationCells = destination.allCellsByIdentifier
            var itemsToReload = [UniqueIdentifier]()

            for (eachId, eachDestCell) in allDestinationCells {
                // if this cell exist in the source, and it has changed
                if let sourceCell = allSourceCells[eachId],
                   eachDestCell != sourceCell {
                    itemsToReload.append(eachId)
                }
            }

            destinationSnapshot.reconfigureItems(itemsToReload)

            // Apply final snapshot with item reconfigure updates
            self.applySnapshot(destinationSnapshot, animated: animated) {

                // Once complete, find and apply section updates, if needed
                let allSourceSections = source.allSectionsByIdentifier
                let allDestinationSections = destination.allSectionsByIdentifier
                var sectionsToReload = Set<UniqueIdentifier>()

                for (eachId, eachDestSection) in allDestinationSections {
                    // If this section exist in the source, and it has changed its SUPPLEMENTARY VIEWS ONLY
                    // then only reload the section if supplementary views have changed
                    // cell changes are handled above
                    if let sourceSection = allSourceSections[eachId],
                       !eachDestSection.supplementaryViewsEqualTo(sourceSection) {
                        sectionsToReload.insert(eachId)
                    }
                }

                // If no section changes, ignore and call completion
                guard !sectionsToReload.isEmpty else {
                    completion?()
                    return
                }

                // Delete empty sections
                var sectionsToDelete = Set<UniqueIdentifier>()
                sectionsToReload.forEach {
                    if destinationSnapshot.numberOfItems(inSection: $0) == 0 {
                        sectionsToDelete.insert($0)
                    }
                }
                sectionsToReload.subtract(sectionsToDelete)

                // Delete or reload sections and apply snapshot
                destinationSnapshot.deleteSections(sectionsToDelete.toArray)
                destinationSnapshot.reloadSections(sectionsToReload.toArray)

                // Apply final section updates
                self.applySnapshot(destinationSnapshot, animated: animated, completion: completion)
            }
    }

    func applySnapshot(_ snapshot: Snapshot, animated: Bool, completion: SnapshotCompletion? = nil) {
        self.apply(snapshot, animatingDifferences: animated, completion: completion)
    }

    func reload(_ viewModel: CollectionViewModel, completion: SnapshotCompletion?) {
        let snapshot = DiffableSnapshot(viewModel: viewModel)
        self.applySnapshotUsingReloadData(snapshot, completion: completion)
    }
}

extension Set {
    fileprivate var toArray: [Self.Element] {
        Array(self)
    }
}
