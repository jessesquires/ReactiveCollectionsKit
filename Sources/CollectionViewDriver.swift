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
    public typealias DidUpdate = @MainActor (CollectionViewDriver) -> Void

    /// The collection view.
    public let view: UICollectionView

    /// A set of options to customize behavior of the driver.
    public let options: CollectionViewDriverOptions

    /// The collection view model.
    @Published public private(set) var viewModel: CollectionViewModel

    /// A scroll view delegate object to receive forwarded events.
    public weak var scrollViewDelegate: UIScrollViewDelegate?

    /// A flow layout delegate object to receive forwarded events.
    public weak var flowLayoutDelegate: UICollectionViewDelegateFlowLayout?

    private let _emptyViewProvider: EmptyViewProvider?

    private var _currentEmptyView: UIView?

    // Avoiding a strong reference to prevent a possible retain cycle.
    // This is typically the view controller that owns `self` (the driver).
    // The caller is responsible for retaining this object for the lifetime of the driver.
    private weak var _cellEventCoordinator: CellEventCoordinator?

    private(set) var _dataSource: DiffableDataSource

    private var _cachedRegistrations = Set<ViewRegistration>()

    /// A debug logger to log messages that track the internal operations of the driver.
    /// The default value is `nil`.
    ///
    /// - Note: You may wish to set this property to the library-provided logger, `RCKLogger.shared`.
    ///         However, you can also provide your own implementation via the `Logging` protocol.
    public var logger: Logging? {
        didSet {
            self._dataSource.logger = self.logger
        }
    }

    // MARK: Init

    /// Initializes a new `CollectionViewDriver`.
    ///
    /// - Parameters:
    ///   - view: The collection view.
    ///   - viewModel: The collection view model.
    ///   - options: A set of options to customize behavior of the driver.
    ///   - emptyViewProvider: An empty view provider.
    ///   - cellEventCoordinator: The cell event coordinator,
    ///                           if you wish to handle cell events outside of your cell view models.
    ///                           **Note: This object is not retained by the driver.**
    ///
    /// - Warning: The driver **does not** retain the `cellEventCoordinator`,
    /// because this object is typically the view controller that owns the driver.
    /// Thus, the caller is responsible for retaining and keeping alive the `cellEventCoordinator`
    /// for the entire lifetime of the driver.
    public init(view: UICollectionView,
                viewModel: CollectionViewModel = .empty,
                options: CollectionViewDriverOptions = .init(),
                emptyViewProvider: EmptyViewProvider? = nil,
                cellEventCoordinator: CellEventCoordinator? = nil) {
        self.view = view
        self.viewModel = viewModel
        self.options = options
        self._emptyViewProvider = emptyViewProvider
        self._cellEventCoordinator = cellEventCoordinator

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
        self._updateViewModel(from: .empty, to: viewModel, animated: false, completion: nil)
    }

    // MARK: State Information

    /// The number of sections displayed by the collection view.
    public var numberOfSections: Int {
        self.viewModel.sections.count
    }

    /// Returns the count of items in the specified section.
    /// - Parameter section: The index of the section for which you want a count of the items.
    /// - Returns: The number of items in the specified section.
    public func numberOfItems(in section: Int) -> Int {
        self.viewModel.sections[section].cells.count
    }

    // MARK: Applying Updates

    /// Updates the collection with the provided `viewModel`.
    /// This method will trigger a diff between the previous view model and the newly provided view model.
    ///
    /// - Parameters:
    ///   - viewModel: The new collection view model.
    ///   - animated: Whether or not to animate updates.
    ///   - completion: A closure to call when the driver finishes diffing and updating the collection view.
    ///                 The driver passes itself to the closure. It is always called on the main thread.
    ///
    /// - Warning: If you provide a `viewModel` with an `id` different from the previous one,
    /// this is considered a *replacement*. By default, the driver will animate the diff between the view models.
    /// You can customize this behavior via the ``options`` for the driver.
    public func update(viewModel new: CollectionViewModel, animated: Bool = true, completion: DidUpdate? = nil) {
        self._updateViewModel(
            from: self.viewModel,
            to: new,
            animated: animated,
            completion: completion
        )
    }

    /// An async version of ``update(viewModel:animated:completion:)``.
    ///
    /// Updates the collection with the provided `viewModel`.
    /// This method will trigger a diff between the previous view model and the newly provided view model.
    ///
    /// - Parameters:
    ///   - viewModel: The new collection view model.
    ///   - animated: Whether or not to animate updates.
    ///
    /// - Warning: If you provide a `viewModel` with an `id` different from the previous one,
    /// this is considered a *replacement*. By default, the driver will animate the diff between the view models.
    /// You can customize this behavior via the ``options`` for the driver.
    public func update(viewModel new: CollectionViewModel, animated: Bool = true) async {
        await withCheckedContinuation { continuation in
            self.update(viewModel: new, animated: animated)
            continuation.resume()
        }
    }

    // MARK: Private

    private func _registerAllViews(for viewModel: CollectionViewModel) {
        let allRegistrations = viewModel.allRegistrations()
        let newRegistrations = allRegistrations.subtracting(self._cachedRegistrations)
        newRegistrations.forEach {
            $0.registerWith(collectionView: self.view)
        }
        self._cachedRegistrations.formUnion(newRegistrations)
    }

    private func _updateViewModel(
        from old: CollectionViewModel,
        to new: CollectionViewModel,
        animated: Bool,
        completion: DidUpdate?
    ) {
        self.viewModel = new
        self._registerAllViews(for: new)

        if self.options.reloadDataOnReplacingViewModel {
            // if given a totally new model, simply reload instead of diff
            guard new.id == old.id else {
                self.logger?.log(
                    """
                    Driver will reload view model.
                    Old:
                    \(old.debugDescription)
                    New:
                    \(new.debugDescription)
                    """
                )

                self._dataSource.reload(self.viewModel) { [weak self] in
                    // Note: UIKit guarantees this closure is called on the main queue.
                    self?._displayEmptyViewIfNeeded(animated: animated, completion: completion)
                }
                return
            }
        }

        self.logger?.log(
            """
            Driver will update view model.
            Old:
            \(old.debugDescription)
            New:
            \(new.debugDescription)
            """
        )

        self._dataSource.applySnapshot(
            from: old,
            to: new,
            animated: animated
        ) { [weak self] in
            // Note: UIKit guarantees this closure is called on the main queue.
            self?._displayEmptyViewIfNeeded(animated: animated, completion: completion)
        }
    }

    private func _displayEmptyViewIfNeeded(animated: Bool, completion: DidUpdate?) {
        if self.viewModel.isEmpty {
            // view model is empty, but we are already displaying the empty state view
            guard self._currentEmptyView == nil else {
                completion?(self)
                return
            }

            // empty state view was not provided
            guard let emptyView = self._emptyViewProvider?.view else {
                completion?(self)
                return
            }

            emptyView.frame = self.view.frame
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.alpha = 0
            self.view.addSubview(emptyView)
            NSLayoutConstraint.activate([
                emptyView.topAnchor.constraint(equalTo: self.view.superview!.topAnchor),
                emptyView.bottomAnchor.constraint(equalTo: self.view.superview!.bottomAnchor),
                emptyView.leadingAnchor.constraint(equalTo: self.view.superview!.leadingAnchor),
                emptyView.trailingAnchor.constraint(equalTo: self.view.superview!.trailingAnchor)
            ])
            self._currentEmptyView = emptyView
            self._animateEmptyView(isHidden: false, animated: animated, completion: completion)
            self.view.isScrollEnabled = false
        } else {
            self._animateEmptyView(isHidden: true, animated: animated, completion: completion)
            self.view.isScrollEnabled = true
        }
    }

    private func _animateEmptyView(isHidden: Bool, animated: Bool, completion: DidUpdate?) {
        guard animated else {
            if isHidden {
                self._currentEmptyView?.removeFromSuperview()
                self._currentEmptyView = nil
            } else {
                self._currentEmptyView?.alpha = 1
            }
            completion?(self)
            return
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self._currentEmptyView?.alpha = isHidden ? 0 : 1
        } completion: { _ in
            if isHidden {
                self._currentEmptyView?.removeFromSuperview()
                self._currentEmptyView = nil
            }
            completion?(self)
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

// MARK: - UICollectionViewDelegate

extension CollectionViewDriver: UICollectionViewDelegate {
    // MARK: Managing the selected cells

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.viewModel.cellViewModel(at: indexPath, in: collectionView).shouldSelect
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        self.viewModel.cellViewModel(at: indexPath, in: collectionView).didSelect(with: self._cellEventCoordinator)
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        self.viewModel.cellViewModel(at: indexPath, in: collectionView).shouldDeselect
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               didDeselectItemAt indexPath: IndexPath) {
        self.viewModel.cellViewModel(at: indexPath, in: collectionView).didDeselect(with: self._cellEventCoordinator)
    }

    // MARK: Managing cell highlighting

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.viewModel.cellViewModel(at: indexPath, in: collectionView).shouldHighlight
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               didHighlightItemAt indexPath: IndexPath) {
        self.viewModel.cellViewModel(at: indexPath, in: collectionView).didHighlight()
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               didUnhighlightItemAt indexPath: IndexPath) {
        self.viewModel.cellViewModel(at: indexPath, in: collectionView).didUnhighlight()
    }

    // MARK: Managing context menus

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               contextMenuConfigurationForItemAt indexPath: IndexPath,
                               point: CGPoint) -> UIContextMenuConfiguration? {
        self.viewModel.cellViewModel(at: indexPath, in: collectionView).contextMenuConfiguration
    }

    // MARK: Tracking the addition and removal of views

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               willDisplay cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {
        self.viewModel._safeCellViewModel(at: indexPath, in: collectionView)?.willDisplay()
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               willDisplaySupplementaryView view: UICollectionReusableView,
                               forElementKind elementKind: String,
                               at indexPath: IndexPath) {
        self.viewModel._safeSupplementaryViewModel(ofKind: elementKind, at: indexPath)?.willDisplay()
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               didEndDisplaying cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {
        self.viewModel._safeCellViewModel(at: indexPath, in: collectionView)?.didEndDisplaying()
    }

    /// :nodoc:
    public func collectionView(_ collectionView: UICollectionView,
                               didEndDisplayingSupplementaryView view: UICollectionReusableView,
                               forElementOfKind elementKind: String,
                               at indexPath: IndexPath) {
        self.viewModel._safeSupplementaryViewModel(ofKind: elementKind, at: indexPath)?.didEndDisplaying()
    }
}

// MARK: - UIScrollViewDelegate

extension CollectionViewDriver: UIScrollViewDelegate {
    // MARK: Responding to scrolling and dragging

    /// :nodoc:
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    /// :nodoc:
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    /// :nodoc:
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        self.scrollViewDelegate?.scrollViewWillEndDragging?(
            scrollView,
            withVelocity: velocity,
            targetContentOffset: targetContentOffset
        )
    }

    /// :nodoc:
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                         willDecelerate decelerate: Bool) {
        self.scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    /// :nodoc:
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        self.scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    /// :nodoc:
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }

    /// :nodoc:
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    /// :nodoc:
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    // MARK: Managing zooming

    /// :nodoc:
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.scrollViewDelegate?.viewForZooming?(in: scrollView)
    }

    /// :nodoc:
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    /// :nodoc:
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView,
                                        with view: UIView?,
                                        atScale scale: CGFloat) {
        self.scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    /// :nodoc:
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }

    // MARK: Responding to scrolling animations

    /// :nodoc:
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    // MARK: Responding to inset changes

    /// :nodoc:
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewDriver: UICollectionViewDelegateFlowLayout {

    private var flowLayout: UICollectionViewFlowLayout? {
        self.view.collectionViewLayout as? UICollectionViewFlowLayout
    }

    // MARK: Getting the size of items

    /// :nodoc:
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        self.flowLayoutDelegate?.collectionView?(
            collectionView,
            layout: collectionViewLayout,
            sizeForItemAt: indexPath
        )
        ?? self.flowLayout?.itemSize
        ?? .zero
    }

    // MARK: Getting the section spacing

    /// :nodoc:
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        self.flowLayoutDelegate?.collectionView?(
            collectionView,
            layout: collectionViewLayout,
            insetForSectionAt: section
        )
        ?? self.flowLayout?.sectionInset
        ?? .zero
    }

    /// :nodoc:
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        self.flowLayoutDelegate?.collectionView?(
            collectionView,
            layout: collectionViewLayout,
            minimumLineSpacingForSectionAt: section
        )
        ?? self.flowLayout?.minimumLineSpacing
        ?? .zero
    }

    /// :nodoc:
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        self.flowLayoutDelegate?.collectionView?(
            collectionView,
            layout: collectionViewLayout,
            minimumInteritemSpacingForSectionAt: section
        )
        ?? self.flowLayout?.minimumInteritemSpacing
        ?? .zero
    }

    // MARK: Getting the header and footer sizes

    /// :nodoc:
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        self.flowLayoutDelegate?.collectionView?(
            collectionView,
            layout: collectionViewLayout,
            referenceSizeForHeaderInSection: section
        )
        ?? self.flowLayout?.headerReferenceSize
        ?? .zero
    }

    /// :nodoc:
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        self.flowLayoutDelegate?.collectionView?(
            collectionView,
            layout: collectionViewLayout,
            referenceSizeForFooterInSection: section
        )
        ?? self.flowLayout?.footerReferenceSize
        ?? .zero
    }
}

// MARK: - CustomDebugStringConvertible

extension CollectionViewDriver {
    override public var debugDescription: String {
        MainActor.assumeIsolated {
            driverDebugDescription(self, self._emptyViewProvider, self._cellEventCoordinator)
        }
    }
}
