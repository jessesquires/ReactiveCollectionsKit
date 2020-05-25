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

    public var viewModel: ContainerViewModel {
        set {
            _assertMainThread()
            self._viewModel = newValue
            self._didUpdateModel(animated: self.animateUpdates, completion: self._didUpdate)
        }
        get {
            self._viewModel
        }
    }

    private var _viewModel: ContainerViewModel {
        didSet {
            _assertMainThread()
            self._didSetModel()
        }
    }

    private let _dataSourceDelegate: _ContainerViewDataSourceDelegate
    private let _differ: _DiffableDataSourceProtocol
    private let _diffingQueue: DispatchQueue?
    private let _didUpdate: DidUpdate?

    // MARK: Init

    public init(view: View,
                viewModel: ContainerViewModel,
                controller: UIViewController,
                animateUpdates: Bool = true,
                diffingQueue: DispatchQueue? = nil,
                didUpdate: DidUpdate? = nil) {
        self.view = view
        self._viewModel = viewModel
        self.animateUpdates = animateUpdates
        self._diffingQueue = diffingQueue
        self._didUpdate = didUpdate
        self._dataSourceDelegate = _ContainerViewDataSourceDelegate(viewModel: viewModel, controller: controller)
        self._differ = _makeDiffableDataSource(with: view)
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
        self._dataSourceDelegate.viewModel = self._viewModel
        self.view._register(viewModel: self._viewModel)
    }

    private func _didUpdateModel(animated: Bool, completion: DidUpdate?) {
        let applyDiff = {
            self._differ.apply(self._viewModel, animated: animated, completion: completion)
        }

        if let queue = self._diffingQueue {
            queue.async(execute: applyDiff)
        } else {
            applyDiff()
        }
    }
}
