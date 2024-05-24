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

extension AnyHashable: @unchecked Sendable { }

final class DiffableDataSource: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>

    typealias SnapshotCompletion = () -> Void

    private let _diffOnBackgroundQueue: Bool

    private lazy var _diffingQueue = DispatchQueue(
        label: "com.jessesquires.ReactiveCollectionsKit",
        qos: .userInteractive,
        autoreleaseFrequency: .workItem
    )

    // MARK: Init

    init(
        view: UICollectionView,
        diffOnBackgroundQueue: Bool,
        cellProvider: @escaping DiffableDataSource.CellProvider,
        supplementaryViewProvider: @escaping DiffableDataSource.SupplementaryViewProvider
    ) {
        self._diffOnBackgroundQueue = diffOnBackgroundQueue
        super.init(collectionView: view, cellProvider: cellProvider)
        self.supplementaryViewProvider = supplementaryViewProvider
    }

    convenience init(view: UICollectionView, diffOnBackgroundQueue: Bool) {
        self.init(
            view: view,
            diffOnBackgroundQueue: diffOnBackgroundQueue,
            cellProvider: { _, _, _ in nil },
            supplementaryViewProvider: { _, _, _ in nil }
        )
    }

    // MARK: Applying snapshots

    func reload(_ viewModel: CollectionViewModel, completion: SnapshotCompletion?) {
        self._performOnDiffingQueueIfNeeded {
            let snapshot = DiffableSnapshot(viewModel: viewModel)
            // UIKit guarantees `completion` is called on the main queue.
            self.applySnapshotUsingReloadData(snapshot, completion: completion)
        }
    }

    func applySnapshot(
        from source: CollectionViewModel,
        to destination: CollectionViewModel,
        animated: Bool,
        completion: SnapshotCompletion?
    ) {
        self._performOnDiffingQueueIfNeeded {
            self._applySnapshot(from: source, to: destination, animated: animated, completion: completion)
        }
    }

    private func _applySnapshot(
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
        let itemsToReload = self._findItemsToReload(from: source, to: destination)
        destinationSnapshot.reconfigureItems(itemsToReload)

        // Apply snapshot with item reload updates.
        self._applySnapshot(destinationSnapshot, animated: animated) {

            // Once the snapshot with item reloads is applied, find and apply section reloads, if needed.
            // This is necessary to update SUPPLEMENTARY VIEWS ONLY.
            // Supplementary views do not get reloaded / reconfigured automatically when they change.
            // To trigger updates on supplementary views, the section must be reloaded.
            // Yes, this kinda sucks.
            //
            // NOTE: this only matters if supplementary views are not static.
            // That is, if they reflect data in the data source.
            //
            // For example, a header with a fixed title (e.g. "My Items") will NOT need to be reloaded.
            // However, a header that displays changing data WILL need to be reloaded.
            // (e.g. "My 10 Items")
            let sectionsToReload = self._findSectionsToReload(from: source, to: destination)

            // If no sections need reloading, we're done.
            guard sectionsToReload.isNotEmpty else {
                completion?()
                return
            }

            // Apply final section updates
            destinationSnapshot.reloadSections(sectionsToReload)
            self._applySnapshot(destinationSnapshot, animated: animated, completion: completion)
        }
    }

    private func _findItemsToReload(
        from source: CollectionViewModel,
        to destination: CollectionViewModel
    ) -> [UniqueIdentifier] {
        // Determine which items need to be reloaded.
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

        return itemsToReload
    }

    private func _findSectionsToReload(
        from source: CollectionViewModel,
        to destination: CollectionViewModel
    ) -> [UniqueIdentifier] {
        let allSourceSections = source.allSectionsByIdentifier

        // Only get sections that have supplementary views.
        let allDestinationSections = destination.allSectionsByIdentifier.filter { _, value in
            value.hasSupplementaryViews
        }

        // If no sections have supplementary views, there's nothing to do.
        guard allDestinationSections.isNotEmpty else {
            return []
        }

        var sectionsToReload = [UniqueIdentifier]()

        // As soon as we find 1 supplementary view in a section that needs reloading,
        // we can mark the whole section for reload and exit early.
        for (sectionId, destinationSection) in allDestinationSections {
            // If this section does not exist in the source, then it is newly inserted.
            // Thus, nothing to do.
            guard let sourceSection = allSourceSections[sectionId] else {
                continue
            }

            // If this section exists in the source,
            // and it has changed its SUPPLEMENTARY VIEWS ONLY,
            // then reload the section.
            // First, check headers and footers.
            if destinationSection.header != sourceSection.header {
                sectionsToReload.append(sectionId)
                continue
            }

            if destinationSection.footer != sourceSection.footer {
                sectionsToReload.append(sectionId)
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
                    sectionsToReload.append(sectionId)
                    break
                }
            }
        }

        // If no section changes, ignore and call completion
        guard sectionsToReload.isNotEmpty else {
            return []
        }

        return sectionsToReload
    }

    private func _applySnapshot(_ snapshot: Snapshot, animated: Bool, completion: SnapshotCompletion? = nil) {
        // UIKit guarantees `completion` is called on the main queue.
        self.apply(snapshot, animatingDifferences: animated, completion: completion)
    }

    private func _performOnDiffingQueueIfNeeded(_ action: @escaping () -> Void) {
        if self._diffOnBackgroundQueue {
            self._diffingQueue.async(execute: action)
        } else {
            assertMainThread()
            action()
        }
    }
}

extension Set {
    fileprivate var toArray: [Self.Element] {
        Array(self)
    }
}
