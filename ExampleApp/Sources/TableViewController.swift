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
import ReactiveCollectionsKit

final class TableViewController: UITableViewController {

    var model: ContainerViewModel!
    var driver: ContainerViewDriver<UITableView>!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.model = ViewModel.makeTableViewModel(controller: self)
        self.driver = ContainerViewDriver(view: self.tableView, model: self.model)

        self.driver.reloadData()
    }
}
