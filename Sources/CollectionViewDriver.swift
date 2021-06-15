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

    public var animateUpdates: Bool

    public var viewModel: CollectionViewModel {
        get {
            self._viewModel
        }
        set {
            _assertMainThread()
            self._viewModel = newValue
            self._didUpdateModel(animated: self.animateUpdates, completion: self._didUpdate)
        }
    }

    private var _viewModel: CollectionViewModel {
        didSet {
            _assertMainThread()
            self._didSetModel()
        }
    }

    // avoiding a strong reference to prevent a retain cycle.
    // this controller owns self.
    // thus, we know the controller must be alive so unowned is safe.
    private unowned var _controller: UIViewController

    private let _differ: _CollectionDiffableDataSource
    private let _didUpdate: DidUpdate?

    // MARK: Init

    public init(view: UICollectionView,
                viewModel: CollectionViewModel,
                controller: UIViewController,
                animateUpdates: Bool = true,
                didUpdate: DidUpdate? = nil) {
        self.view = view
        self._viewModel = viewModel
        self._controller = controller
        self.animateUpdates = animateUpdates
        self._didUpdate = didUpdate
        self._differ = _CollectionDiffableDataSource(view: view)
        super.init()
        self.view.dataSource = self
        self.view.delegate = self
        self._didSetModel()
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

    private func _didSetModel() {
        self.view._register(viewModel: self._viewModel)
    }

    private func _didUpdateModel(animated: Bool, completion: DidUpdate?) {
        self._differ.apply(self._viewModel, animated: animated, completion: completion)
    }
}

// MARK: UICollectionViewDataSource

extension CollectionViewDriver: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfItems(in: section)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView._dequeueAndConfigureCell(for: self.viewModel, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView._dequeueAndConfigureSupplementaryView(for: SupplementaryViewKind(collectionElementKind: kind),
                                                             model: self.viewModel,
                                                             at: indexPath)!
    }
}

// MARK: UICollectionViewDelegate

extension CollectionViewDriver: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel[indexPath].didSelect(indexPath, collectionView, self._controller)
    }

    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.viewModel[indexPath].shouldHighlight
    }
}
