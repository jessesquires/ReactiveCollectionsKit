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

struct UncheckedCompletion: @unchecked Sendable {
    typealias Block = () -> Void

    let block: Block?

    init(_ block: Block?) {
        self.block = {
            assertMainThread()
            block?()
        }
    }
}

@MainActor
final class DiffableDataSource: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>

    typealias SnapshotCompletion = () -> Void

    // Avoid retaining the collection view, we know it is owned and kept alive by the driver.
    // Thus, unowned is safe here.
    private unowned let _collectionView: UICollectionView

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
        self._collectionView = view
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
        let snapshot = DiffableSnapshot(viewModel: viewModel)
        self._applyReloadSnapshot(snapshot, completion: UncheckedCompletion(completion))
    }

    func applySnapshot(
        from source: CollectionViewModel,
        to destination: CollectionViewModel,
        animated: Bool,
        completion: SnapshotCompletion?
    ) {
        // Build initial destination snapshot, then make adjustments below.
        var destinationSnapshot = DiffableSnapshot(viewModel: destination)

        // Apply item reconfigures, then supplementary view reconfigures.
        // Note: "reconfigure" is a lighter weight, more efficient "reload".
        //
        // Unfortunately headers, footers, and other supplementary views
        // do not get properly reconfigured or reloaded if they display dynamic data.
        // This is a shortcoming in UIKit. The APIs we need to do this do not exist.
        // Ideally, `DiffableDataSource` would offer the same APIs for supplementary views
        // as it does for items and sections.
        //
        // Generally speaking, hard-reloading an entire section is the only way to get
        // headers, footers, and other supplementary views to reload/reconfigure.
        // That sucks. Luckily, we can do better.
        //
        // Below is a 2-step process that is necessary to preserve collection view animations
        // and prevent UIKit data source internal inconsistency exceptions.

        // Find and perform item (cell) updates first.
        // Add the item reconfigure updates to the snapshot.
        let itemsToReconfigure = self._findItemsToReconfigure(from: source, to: destination)
        destinationSnapshot.reconfigureItems(itemsToReconfigure)

        // Apply the snapshot with item reconfigure updates.
        self._applyDiffSnapshot(destinationSnapshot, animated: animated, completion: UncheckedCompletion {

            // Once the snapshot with item reconfigures is applied,
            // we need to find and apply supplementary view reconfigures, if needed.
            //
            // This is necessary to update all headers, footers, and supplementary views.
            // Per notes above, supplementary views do not get reloaded / reconfigured
            // automatically by `DiffableDataSource` when they change.
            //
            // To trigger updates on supplementary views with the existing APIs,
            // the entire section must be reloaded. Yes, that sucks. We don't want to do that.
            // That causes all items in the section to be hard-reloaded, too.
            // Aside from the performance impact, doing that results in an ugly UI "flash"
            // for all item cells in the collection. Gross.
            //
            // However, we can actually do much better than a hard reload!
            // Instead of reloading the entire section, we can find and compare
            // the supplementary views and manually reconfigure them if they changed.
            //
            // NOTE: this only matters if supplementary views are not static.
            // That is, if they reflect data in the data source.
            //
            // For example, a header with a fixed title (e.g. "My Items") will NOT need to be reloaded.
            // However, a header that displays changing data WILL need to be reloaded.
            // (e.g. "My 10 Items")

            // Check all the supplementary views and reconfigure them, if needed.
            self._reconfigureSupplementaryViewsIfNeeded(from: source, to: destination)

            // Finally, we're done and can call completion.
            completion?()
        })
    }

    private func _findItemsToReconfigure(
        from source: CollectionViewModel,
        to destination: CollectionViewModel
    ) -> [UniqueIdentifier] {
        let allSourceCells = source.allCellsByIdentifier
        let allDestinationCells = destination.allCellsByIdentifier

        var itemsToReconfigure = [UniqueIdentifier]()

        for (cellId, destinationCell) in allDestinationCells {
            let sourceCell = allSourceCells[cellId]

            // If this cell exist in the source, and it has changed, then reload it.
            if destinationCell != sourceCell {
                itemsToReconfigure.append(cellId)
            }
        }

        return itemsToReconfigure
    }

    private func _reconfigureSupplementaryViewsIfNeeded(
        from source: CollectionViewModel,
        to destination: CollectionViewModel
    ) {
        let allSourceSections = source.allSectionsByIdentifier

        for sectionIndex in 0..<destination.sections.count {
            let destinationSection = destination.sections[sectionIndex]

            // If this section does not have any supplementary views, skip it.
            guard destinationSection.hasSupplementaryViews else {
                continue
            }

            // If this section does not exist in the source,
            // then it is newly inserted. Thus, nothing to do.
            guard let sourceSection = allSourceSections[destinationSection.id] else {
                continue
            }

            // This section exists in the source.
            // Check if it has changed its supplementary views.

            // First, check and reconfigure header.
            if let destinationHeader = destinationSection.header,
               let sourceHeader = sourceSection.header,
               destinationHeader != sourceHeader {
                self._reconfigureSupplementaryView(
                    model: destinationHeader,
                    item: 0,
                    section: sectionIndex
                )
            }

            // Second, check and reconfigure footer.
            if let destinationFooter = destinationSection.footer,
               let sourceFooter = sourceSection.footer,
               destinationFooter != sourceFooter {
                self._reconfigureSupplementaryView(
                    model: destinationFooter,
                    item: 0,
                    section: sectionIndex
                )
            }

            // Third, check all supplementary views.
            let allSourceSectionSupplementaryViews = sourceSection.allSupplementaryViewsByIdentifier

            for viewIndex in 0..<destinationSection.supplementaryViews.count {
                let destinationView = destinationSection.supplementaryViews[viewIndex]

                // If this view does not exist in the source,
                // then it is newly added. Thus, nothing to do.
                guard let sourceView = allSourceSectionSupplementaryViews[destinationView.id] else {
                    continue
                }

                // Check and reconfigure supplementary view.
                if destinationView != sourceView {
                    self._reconfigureSupplementaryView(
                        model: destinationView,
                        item: viewIndex,
                        section: sectionIndex
                    )
                }
            }
        }
    }

    private func _reconfigureSupplementaryView(model: AnySupplementaryViewModel, item: Int, section: Int) {
        let indexPath = IndexPath(item: item, section: section)
        if let view = self._collectionView.supplementaryView(forElementKind: model._kind, at: indexPath) {
            model.configure(view: view)
        }
    }

    // MARK: Diffing

    private func _applyDiffSnapshot(_ snapshot: Snapshot, animated: Bool, completion: UncheckedCompletion) {
        self._performOnDiffingQueueIfNeeded {
            // UIKit guarantees `completion` is called on the main queue.
            self.apply(snapshot, animatingDifferences: animated, completion: completion.block)
        }
    }

    func _applyReloadSnapshot(_ snapshot: Snapshot, completion: UncheckedCompletion) {
        self._performOnDiffingQueueIfNeeded {
            // UIKit guarantees `completion` is called on the main queue.
            self.applySnapshotUsingReloadData(snapshot, completion: completion.block)
        }
    }

    private func _performOnDiffingQueueIfNeeded(_ action: @Sendable @escaping () -> Void) {
        if self._diffOnBackgroundQueue {
            self._diffingQueue.async(execute: action)
        } else {
            assertMainThread()
            action()
        }
    }
}
