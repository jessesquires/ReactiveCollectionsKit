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
        view.collectionViewLayout as! UICollectionViewCompositionalLayout
    }

    public var animateUpdates: Bool

    public var viewModel: CollectionViewModel {
        didSet {
            _assertMainThread()
            self._registerAllViews()
            self._didUpdateModel(animated: self.animateUpdates, completion: self._didUpdate)
        }
    }

    // avoiding a strong reference to prevent a retain cycle.
    // this controller owns self.
    // thus, we know the controller must be alive so unowned is safe.
    private unowned var _controller: UIViewController

    private let _dataSource: _DiffableDataSource
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
        self._dataSource = _DiffableDataSource(view: view, viewModel: viewModel)

        super.init()

        self.view.dataSource = self._dataSource
        self.view.delegate = self
        self._registerAllViews()
        self._didUpdateModel(animated: false, completion: nil)
    }

    // MARK: Public

    public func reloadData() {
        self.view.reloadData()
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

    private func _didUpdateModel(animated: Bool, completion: DidUpdate?) {
        self._dataSource.apply(self.viewModel, animated: animated, completion: completion)
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
