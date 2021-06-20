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

    public var layout: UICollectionViewLayout {
        view.collectionViewLayout
    }

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

    private let _dataSource: _DiffableDataSource
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
        self._dataSource = _DiffableDataSource(view: view, viewModel: viewModel)

        super.init()

        self.view.dataSource = self._dataSource
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
        self._dataSource.apply(self._viewModel, animated: animated, completion: completion)
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
