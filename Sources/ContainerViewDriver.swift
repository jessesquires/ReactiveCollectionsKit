//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit

public final class ContainerViewDriver<View: UIView & CellContainerViewProtocol> {

    public let view: View

    public let model: ContainerViewModel

    private let _dataSource: ContainerViewDataSource

    public init(view: View, model: ContainerViewModel) {
        self.view = view
        self.model = model

        self._dataSource = ContainerViewDataSource(model: model)
        self.view.dataSource = self._dataSource as? View.DataSource
        self.view.delegate = self._dataSource as? View.Delegate
    }
}
