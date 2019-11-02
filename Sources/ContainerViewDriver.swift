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
            assertMainThread()
            self._model = newValue
            self._didUpdateModel()
        }
        get {
            self._model
        }
    }

    private var _model: ContainerViewModel {
        didSet {
            assertMainThread()
            self._didSetModel()
        }
    }

    private let _dataSourceDelegate: ContainerViewDataSourceDelegate
    private let _differ: DiffableDataSourceProtocol

    // MARK: Init

    public init(view: View, model: ContainerViewModel) {
        self.view = view
        self._model = model
        self._dataSourceDelegate = ContainerViewDataSourceDelegate(model: model)
        self._differ = makeDiffableDataSource(with: view)
        self.view.dataSource = self._dataSourceDelegate as? View.DataSource
        self.view.delegate = self._dataSourceDelegate as? View.Delegate
        self._didSetModel()
        self._didUpdateModel(animatingDifferences: false)
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

    private func _didUpdateModel(animatingDifferences: Bool = true) {
        let snapshot = DiffableSnapshot(model: self._model)
        self._differ.apply(snapshot, animatingDifferences: animatingDifferences, completion: nil)
    }
}
