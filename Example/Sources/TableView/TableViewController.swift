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

import ReactiveCollectionsKit
import UIKit

final class TableViewController: UITableViewController {

    var driver: ContainerViewDriver<UITableView>!

    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ViewModel.makeTableViewModel(model: self.model)
        self.driver = ContainerViewDriver(view: self.tableView, viewModel: viewModel, controller: self)

        self.addShuffle(action: #selector(shuffle))
    }

    @objc
    func shuffle() {
        self.model = Model(shuffle: true)
        self.driver.viewModel = ViewModel.makeTableViewModel(model: self.model)
    }
}
