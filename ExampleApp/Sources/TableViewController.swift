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

    var model: ContainerViewModel!
    var driver: ContainerViewDriver<UITableView>!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.model = ViewModel.makeTableViewModel(controller: self)
        self.driver = ContainerViewDriver(view: self.tableView, model: self.model)

        self.driver.reloadData()
    }
}
