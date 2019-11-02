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

    public typealias DidUpdate = () -> Void

    public let view: View

    public var animateUpdates: Bool

    public let didUpdate: DidUpdate?

    public var viewModel: ContainerViewModel {
        set {
            assertMainThread()
            self._viewModel = newValue
            self._didUpdateModel(animated: self.animateUpdates, completion: self.didUpdate)
        }
        get {
            self._viewModel
        }
    }

    private var _viewModel: ContainerViewModel {
        didSet {
            assertMainThread()
            self._didSetModel()
        }
    }

    private let _dataSourceDelegate: ContainerViewDataSourceDelegate
    private let _differ: DiffableDataSourceProtocol

    // MARK: Init

    public init(view: View,
                viewModel: ContainerViewModel,
                animateUpdates: Bool = true,
                didUpdate: DidUpdate? = nil) {
        self.view = view
        self._viewModel = viewModel
        self.animateUpdates = animateUpdates
        self.didUpdate = didUpdate
        self._dataSourceDelegate = ContainerViewDataSourceDelegate(model: viewModel)
        self._differ = makeDiffableDataSource(with: view)
        self.view.dataSource = self._dataSourceDelegate as? View.DataSource
        self.view.delegate = self._dataSourceDelegate as? View.Delegate
        self._didSetModel()
        self._didUpdateModel(animated: false, completion: nil)
    }

    // MARK: Public

    public func reloadData() {
        self.view.reloadData()
    }

    // MARK: Private

    private func _didSetModel() {
        self._dataSourceDelegate.model = self._viewModel
        self.view.register(viewModel: self._viewModel)
    }

    private func _didUpdateModel(animated: Bool, completion: DidUpdate?) {
        self._differ.apply(self._viewModel, animated: animated, completion: completion)
    }
}
