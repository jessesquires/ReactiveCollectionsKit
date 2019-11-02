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

public final class ContainerViewDriver<View: UIView & CellContainerViewProtocol> {

    public let view: View

    public var model: ContainerViewModel {
        set {
            assert(Thread.isMainThread, "\(#function) must be used on main thread only")
            self._updateModel(from: self._model, to: newValue)
        }
        get {
            self._model
        }
    }

    private var _model: ContainerViewModel {
        didSet {
            assert(Thread.isMainThread, "\(#function) must be used on main thread only")
            self._didSetModel()
        }
    }

    private let _dataSourceDelegate: ContainerViewDataSourceDelegate
    private let _diffableDataSource: DiffableDataSourceProtocol

    // MARK: Init

    public init(view: View, model: ContainerViewModel) {
        self.view = view
        self._model = model
        self._dataSourceDelegate = ContainerViewDataSourceDelegate(model: model)
        self._diffableDataSource = makeDiffableDataSource(with: view)
        self.view.dataSource = self._dataSourceDelegate as? View.DataSource
        self.view.delegate = self._dataSourceDelegate as? View.Delegate
        self._didSetModel()
    }

    // MARK: Public

    public func reloadData() {
        self.view.reloadData()
    }

    // MARK: Private

    private func _didSetModel() {
        self._dataSourceDelegate.model = self._model
        self.view.register(viewModel: self._model)
    }

    private func _updateModel(from old: ContainerViewModel, to new: ContainerViewModel) {
        self._model = new
        self.reloadData()

        #warning("TODO: this doesn't work :(")
        // let snapshot = DiffableSnapshot(containerViewModel: new)
        // self._diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}
