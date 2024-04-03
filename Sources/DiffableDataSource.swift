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
        completion: SnapshotCompletion?
    ) {
        // Build initial destination snapshot, then make adjustments below.
        var destinationSnapshot = DiffableSnapshot(viewModel: destination)

        // Apply item reloads, then section reloads.
        // Reloading a section is required to properly reload headers, footers, and other supplementary views.
        // This 2-step process is necessary to preserve collection view animations
        // and prevent UIKit data source internal inconsistency exceptions.
        //
        // If we only reloaded a section (instead of reloading items first),
        // there are 2 problems:
        //   1. item updates would not animate correctly, because the whole section is reloaded.
        //   2. item inserts/deletes could trigger an internal inconsistency exception.

        // Find and perform item (cell) updates first.
        let allSourceCells = source.allCellsByIdentifier
        let allDestinationCells = destination.allCellsByIdentifier
        var itemsToReload = [UniqueIdentifier]()

        for (cellId, destinationCell) in allDestinationCells {
            let sourceCell = allSourceCells[cellId]

            // If this cell exist in the source, and it has changed, then reload it.
            if destinationCell != sourceCell {
                itemsToReload.append(cellId)
            }
        }

        destinationSnapshot.reconfigureItems(itemsToReload)

        // Apply snapshot with item reload updates.
        self.applySnapshot(destinationSnapshot, animated: animated) {
            // Once item reloads are complete, find and apply section reloads, if needed.
            // This is necessary to update SUPPLEMENTARY VIEWS ONLY.
            // Supplementary views do not get reloaded / reconfigured automatically when they change.
            // To trigger updates on supplementary views, the section must be reloaded.
            // Yes, this kinda sucks.

            let allSourceSections = source.allSectionsByIdentifier

            // Only get sections that have supplementary views.
            let allDestinationSections = destination.allSectionsByIdentifier.filter { _, value in
                value.hasSupplementaryViews
            }

            // If no sections have supplementary views, there's nothing to do.
            guard allDestinationSections.isNotEmpty else {
                completion?()
                return
            }

            var sectionsToReload = Set<UniqueIdentifier>()

            // As soon as we find 1 supplementary view in a section that needs reloading,
            // we can mark the whole section for reload and exit early.
            for (sectionId, destinationSection) in allDestinationSections {
                // If this section does not exist in the source, then it is newly inserted.
                // Thus, nothing to do.
                guard let sourceSection = allSourceSections[sectionId] else {
                    continue
                }

                // If this section exist in the source,
                // and it has changed its SUPPLEMENTARY VIEWS ONLY,
                // then only reload the section.
                // First, check headers and footers.
                if destinationSection.header != sourceSection.header {
                    sectionsToReload.insert(sectionId)
                    continue
                }

                if destinationSection.footer != sourceSection.footer {
                    sectionsToReload.insert(sectionId)
                    continue
                }

                // Next, check all supplementary views.
                let allSourceSectionSupplementaryViews = sourceSection.allSupplementaryViewsByIdentifier

                for destinationView in destinationSection.supplementaryViews {
                    // If this view does not exist in the source, then it is newly added.
                    // Thus, nothing to do.
                    guard let sourceView = allSourceSectionSupplementaryViews[destinationView.id] else {
                        continue
                    }

                    // After finding one view that needs reloading, we can stop,
                    // because we have to reload the whole section anyway.
                    if destinationView != sourceView {
                        sectionsToReload.insert(sectionId)
                        break
                    }
                }
            }

            // If no section changes, ignore and call completion
            guard sectionsToReload.isNotEmpty else {
                completion?()
                return
            }

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
