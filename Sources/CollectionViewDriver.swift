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

/// Represents the main entry-point to the library, and underlying `UICollectionView` components.
/// A `CollectionViewDriver` is responsible for "driving" the collection view.
/// It handles all layout, data source, delegate, and diffing operations.
@MainActor
public final class CollectionViewDriver: NSObject {
    /// A closure type used to notify callers of collection view updates.
    public typealias DidUpdate = (CollectionViewDriver) -> Void

    /// The collection view.
    public let view: UICollectionView

    /// The collection view compositional layout.
    public var layout: UICollectionViewCompositionalLayout {
        self.view.collectionViewLayout as! UICollectionViewCompositionalLayout
    }

    /// A set of options to customize behavior of the driver.
    public let options: CollectionViewDriverOptions

    /// The collection view model.
    ///
    /// - Note: Setting this property to a new value will trigger diffing and collection view updates.
    ///
    /// - Warning: If you provide a `viewModel` with an `id` different from the previous one,
    /// this is considered a *replacement*. By default, the driver will animate the diff between the view models.
    /// You can customize this behavior via the ``options`` for the driver.
    @Published public var viewModel: CollectionViewModel {
        didSet {
            self._didUpdateModel(from: oldValue, to: self.viewModel)
        }
    }

    private let _emptyViewProvider: EmptyViewProvider?

    private var _currentEmptyView: UIView?

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
    ///   - options: A set of options to customize behavior of the driver.
    ///   - emptyViewProvider: An empty view provider.
    ///   - cellEventCoordinator: The cell event coordinator,
    ///                           if you wish to handle cell events outside of your cell view models.
    ///                           **Note: This object is not retained by the driver.**
    ///   - didUpdate: A closure to call when the driver finishes diffing and updating the collection view.
    ///                The driver passes itself to the closure. This will always be called on the main thread.
    ///
    /// - Warning: The driver **does not** retain the `cellEventCoordinator`,
    /// because this object is typically the view controller that owns the driver.
    /// Thus, the caller is responsible for retaining and keeping alive the `cellEventCoordinator`
    /// for the entire lifetime of the driver.
    public init(view: UICollectionView,
                layout: UICollectionViewCompositionalLayout,
                viewModel: CollectionViewModel = CollectionViewModel(id: UUID()),
                options: CollectionViewDriverOptions = CollectionViewDriverOptions(),
                emptyViewProvider: EmptyViewProvider?,
                cellEventCoordinator: CellEventCoordinator?,
                didUpdate: DidUpdate? = nil) {
        self.view = view
        self.view.collectionViewLayout = layout
        self.viewModel = viewModel
        self._emptyViewProvider = emptyViewProvider
        self._cellEventCoordinator = cellEventCoordinator
        self.options = options
        self._didUpdate = didUpdate

        // workaround for swift initialization rules.
        // the "real" init is below.
        self._dataSource = DiffableDataSource(view: view, diffOnBackgroundQueue: false)

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
            diffOnBackgroundQueue: options.diffOnBackgroundQueue,
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

    /// The number of sections displayed by the collection view.
    var numberOfSections: Int {
        self.viewModel.sections.count
    }

    /// Returns the count of items in the specified section.
    /// - Parameter section: The index of the section for which you want a count of the items.
    /// - Returns: The number of items in the specified section.
    func numberOfItems(in section: Int) -> Int {
        self.viewModel.sections[section].cells.count
    }

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

        if self.options.reloadDataOnReplacingViewModel {
            // if given a totally new model, simply reload instead of diff
            guard new.id == old.id else {
                self._dataSource.reload(self.viewModel) { [unowned self] in
                    // UIKit guarantees this closure is called on the main queue.
                    self._handleDidUpdate()
                }
                return
            }
        }

        self._dataSource.applySnapshot(
            from: old,
            to: new,
            animated: self.options.animateUpdates
        ) { [unowned self] in
            // UIKit guarantees this closure is called on the main queue.
            self._handleDidUpdate()
        }
    }

    private func _handleDidUpdate() {
        self._didUpdate?(self)
        self._displayEmptyViewIfNeeded()
    }

    private func _displayEmptyViewIfNeeded() {
        if self.viewModel.isEmpty {
            guard self._currentEmptyView == nil else { return }
            guard let emptyView = self._emptyViewProvider?.view else { return }

            emptyView.frame = self.view.frame
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.alpha = 0
            self.view.superview?.addSubview(emptyView)
            NSLayoutConstraint.activate([
                emptyView.topAnchor.constraint(equalTo: self.view.superview!.topAnchor),
                emptyView.bottomAnchor.constraint(equalTo: self.view.superview!.bottomAnchor),
                emptyView.leadingAnchor.constraint(equalTo: self.view.superview!.leadingAnchor),
                emptyView.trailingAnchor.constraint(equalTo: self.view.superview!.trailingAnchor)
            ])
            self._currentEmptyView = emptyView
            self._animateEmptyView(isHidden: false)
        } else {
            self._animateEmptyView(isHidden: true)
        }
    }

    private func _animateEmptyView(isHidden: Bool) {
        guard self.options.animateUpdates else {
            if isHidden {
                self._currentEmptyView?.removeFromSuperview()
                self._currentEmptyView = nil
            } else {
                self._currentEmptyView?.alpha = 1
            }
            return
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self._currentEmptyView?.alpha = isHidden ? 0 : 1
        } completion: { _ in
            if isHidden {
                self._currentEmptyView?.removeFromSuperview()
                self._currentEmptyView = nil
            }
        }
    }

    private func _cellProvider(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        identifier: UniqueIdentifier
    ) -> UICollectionViewCell {
        let cell = self.viewModel.cellViewModel(for: identifier)
        precondition(cell != nil, "Inconsistent state. Cell with identifier \(identifier) does not exist.")
        return cell!.dequeueAndConfigureCellFor(collectionView: collectionView, at: indexPath)
    }

    private func _supplementaryViewProvider(
        collectionView: UICollectionView,
        elementKind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView? {
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
