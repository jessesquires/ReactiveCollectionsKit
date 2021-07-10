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

public final class CollectionViewDriver: NSObject {
    public typealias DidUpdate = () -> Void

    public let view: UICollectionView

    public var layout: UICollectionViewCompositionalLayout {
        self.view.collectionViewLayout as! UICollectionViewCompositionalLayout
    }

    public var animateUpdates: Bool

    public var viewModel: CollectionViewModel {
        didSet {
            _assertMainThread()
            self._didUpdateModel(from: oldValue, to: self.viewModel)
        }
    }

    // avoiding a strong reference to prevent a retain cycle.
    // this controller owns `self` (the driver).
    // thus, we know the controller *must* be alive, meaning `unowned` is safe to use.
    private unowned var _controller: UIViewController

    private(set) var _dataSource: _DiffableDataSource
    private let _didUpdate: DidUpdate?
    private var _cachedRegistrations = Set<ViewRegistration>()

    // MARK: Init

    public init(view: UICollectionView,
                layout: UICollectionViewCompositionalLayout,
                viewModel: CollectionViewModel,
                controller: UIViewController,
                animateUpdates: Bool = true,
                didUpdate: DidUpdate? = nil) {
        self.view = view
        self.view.collectionViewLayout = layout
        self.viewModel = viewModel
        self._controller = controller
        self.animateUpdates = animateUpdates
        self._didUpdate = didUpdate

        // workaround for swift initialization rules.
        // the "real" init is below.
        self._dataSource = _DiffableDataSource(view: view)

        super.init()

        // because view model is a value type, we cannot capture it directly.
        // it is constantly updated, and a capture would prevent updates to the data source.
        //
        // thus, we must capture `self` (the driver), which is a reference type.
        // then we can dequeue can configure cells from the latest `self.viewModel`.
        //
        // using `unowned` for each closure breaks a potential cycle, and is safe to use here.
        // `self` owns the `_dataSource`, so we know that `self` will always exist.
        self._dataSource = _DiffableDataSource(
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
        self._registerAllViews()
        self._dataSource.reload(viewModel, completion: nil)
    }

    // MARK: Public

    public func reloadData() {
        self._dataSource.reload(self.viewModel, completion: self._didUpdate)
    }

    func numberOfSections() -> Int {
        self.viewModel.sections.count
    }

    func numberOfItems(in section: Int) -> Int {
        self.viewModel.sections[section].cellViewModels.count
    }

    // MARK: Private

    private func _registerAllViews() {
        let allRegistrations = self.viewModel.allRegistrations
        let newRegistrations = allRegistrations.subtracting(self._cachedRegistrations)
        newRegistrations.forEach {
            $0.registerWith(collectionView: self.view)
        }
        self._cachedRegistrations.formUnion(newRegistrations)
    }

    private func _didUpdateModel(from old: CollectionViewModel, to new: CollectionViewModel) {
        self._registerAllViews()
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
        let cell = self.viewModel.cell(at: indexPath)
        return cell.dequeueAndConfigureCellFor(collectionView: collectionView, at: indexPath)
    }

    private func _supplementaryViewProvider(
        collectionView: UICollectionView,
        elementKind: String,
        indexPath: IndexPath) -> UICollectionReusableView? {
        let supplementaryView = self.viewModel.supplementaryView(ofKind: elementKind, at: indexPath)
        return supplementaryView?.dequeueAndConfigureViewFor(collectionView: collectionView, at: indexPath)
    }
}

// MARK: UICollectionViewDelegate

extension CollectionViewDriver: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.cell(at: indexPath).didSelect(with: self._controller)
    }

    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.viewModel.cell(at: indexPath).shouldHighlight
    }
}
