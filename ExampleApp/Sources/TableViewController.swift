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

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ViewModel.makeTableViewModel(controller: self)
        self.driver = ContainerViewDriver(view: self.tableView, viewModel: viewModel)
        self.driver.reloadData()

        self.addShuffle(action: #selector(shuffle))
    }

    @objc
    func shuffle() {
        self.driver.viewModel = ViewModel.makeTableViewModel(controller: self, shuffled: true)
    }
}
