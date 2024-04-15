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

import Combine
import Foundation
import UIKit

/// Represents the main entry-point to the underlying `UICollectionView`.
/// A `CollectionViewDriver` is responsible for "driving" the collection view.
/// It handles all layout, data source, delegate, and diffing operations.
public final class CollectionViewDriver: NSObject {
    public typealias DidUpdate = () -> Void

    public let view: UICollectionView

    public var layout: UICollectionViewCompositionalLayout {
        self.view.collectionViewLayout as! UICollectionViewCompositionalLayout
    }

    public var animateUpdates: Bool

    @Published public var viewModel: CollectionViewModel {
        didSet {
            // TODO: diff on bg queue?
            assertMainThread()
            self._didUpdateModel(from: oldValue, to: self.viewModel)
        }
    }

    // Avoiding a strong reference to prevent a possible retain cycle.
    // This is typically the view controller that owns `self` (the driver).
    // The caller is responsible for retaining this object for the lifetime of the driver.
    private weak var _cellEventCoordinator: CellEventCoordinator?

    private(set) var _dataSource: DiffableDataSource

    private let _didUpdate: DidUpdate?

    private var _cachedRegistrations = Set<ViewRegistration>()

    // MARK: Init

    /// Initializes a new `CollectionViewDriver`.
    ///
    /// - Parameters:
    ///   - view: The collection view.
    ///   - layout: The collection view layout.
    ///   - viewModel: The collection view model.
    ///   - cellEventCoordinator: The cell event coordinator,
    ///                           if you wish to handle cell events outside of your cell view models.
    ///                           **Note: This object is not retained by the driver.**
    ///   - animateUpdates: Specifies whether or not to animate updates.
    ///                     Pass `true` to animate, `false` otherwise.
    ///   - didUpdate: A closure to call when the driver finishes diffing and updating the collection view.
    ///
    /// - Warning: The driver **does not** retain the `cellEventCoordinator`,
    /// because this object is typically the view controller that owns the driver.
    /// Thus, the caller is responsible for retaining and keeping alive the `cellEventCoordinator`
    /// for the entire lifetime of the driver.
    public init(view: UICollectionView,
                layout: UICollectionViewCompositionalLayout,
                viewModel: CollectionViewModel = CollectionViewModel(),
                cellEventCoordinator: CellEventCoordinator?,
                animateUpdates: Bool = true,
                didUpdate: DidUpdate? = nil) {
        self.view = view
        self.view.collectionViewLayout = layout
        self.viewModel = viewModel
        self._cellEventCoordinator = cellEventCoordinator
        self.animateUpdates = animateUpdates
        self._didUpdate = didUpdate

        // workaround for swift initialization rules.
        // the "real" init is below.
        self._dataSource = DiffableDataSource(view: view)

        super.init()

        // because view model is a value type, we cannot capture it directly.
        // it is constantly updated, and a capture would prevent updates to the data source.
        //
        // thus, we must capture `self` (the driver), which is a reference type.
        // then we can dequeue can configure cells from the latest `self.viewModel`.
        //
        // using `unowned` for each closure breaks a potential cycle, and is safe to use here.
        // `self` owns the `_dataSource`, so we know that `self` will always exist.
        self._dataSource = DiffableDataSource(
            view: view,
            cellProvider: { [unowned self] view, indexPath, itemIdentifier in
            self._cellProvider(
                collectionView: view,
                indexPath: indexPath,
                identifier: itemIdentifier
            )
        },
            supplementaryViewProvider: { [unowned self] view, elementKind, indexPath in
            self._supplementaryViewProvider(
                collectionView: view,
                elementKind: elementKind,
                indexPath: indexPath
            )
        })

        self.view.dataSource = self._dataSource
        self.view.delegate = self
        self._registerAllViews(for: viewModel)
        self._dataSource.reload(viewModel, completion: nil)
    }

    // MARK: State information

    func numberOfSections() -> Int {
        self.viewModel.sections.count
    }

    func numberOfItems(in section: Int) -> Int {
        self.viewModel.sections[section].cells.count
    }

    // MARK: Modifying data

    public func reloadData() {
        self._dataSource.reload(self.viewModel, completion: self._didUpdate)
    }

    // TODO:
    // - reload with view model, layout (?)
    // - update with view model, layout (?), animated

    // MARK: Private

    private func _registerAllViews(for viewModel: CollectionViewModel) {
        let allRegistrations = viewModel.allRegistrations
        let newRegistrations = allRegistrations.subtracting(self._cachedRegistrations)
        newRegistrations.forEach {
            $0.registerWith(collectionView: self.view)
        }
        self._cachedRegistrations.formUnion(newRegistrations)
    }

    private func _didUpdateModel(from old: CollectionViewModel, to new: CollectionViewModel) {
        self._registerAllViews(for: new)
        self._dataSource.applySnapshot(
            from: old,
            to: new,
            animated: self.animateUpdates,
            completion: self._didUpdate
        )
    }

    private func _cellProvider(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        identifier: UniqueIdentifier) -> UICollectionViewCell {
        let cell = self.viewModel.cellViewModel(for: identifier)
        precondition(cell != nil, "Inconsistent state. Cell with identifier \(identifier) does not exist.")
        return cell!.dequeueAndConfigureCellFor(collectionView: collectionView, at: indexPath)
    }

    private func _supplementaryViewProvider(
        collectionView: UICollectionView,
        elementKind: String,
        indexPath: IndexPath) -> UICollectionReusableView? {
        let supplementaryView = self.viewModel.supplementaryViewModel(ofKind: elementKind, at: indexPath)
        return supplementaryView?.dequeueAndConfigureViewFor(collectionView: collectionView, at: indexPath)
    }
}

// MARK: UICollectionViewDelegate

extension CollectionViewDriver: UICollectionViewDelegate {
    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        self.viewModel.cellViewModel(at: indexPath).didSelect(with: self._cellEventCoordinator)
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.viewModel.cellViewModel(at: indexPath).shouldHighlight
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               contextMenuConfigurationForItemAt indexPath: IndexPath,
                               point: CGPoint) -> UIContextMenuConfiguration? {
        self.viewModel.cellViewModel(at: indexPath).contextMenuConfiguration
    }
}
