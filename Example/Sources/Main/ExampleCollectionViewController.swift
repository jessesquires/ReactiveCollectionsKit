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

class ExampleCollectionViewController: UICollectionViewController {
    var driver: CollectionViewDriver!

    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addShuffle(action: #selector(shuffle))
        self.addReload(action: #selector(reload))
    }

    @objc
    func shuffle() {
        self.model.shuffle()
    }

    // TODO: reset and reload
    @objc
    func reload() {
        self.driver.reloadData()
    }

    func deleteAt(indexPath: IndexPath) {
        self.model.deleteModelAt(indexPath: indexPath)
    }

    func toggleFavoriteAt(indexPath: IndexPath) {
        self.model.toggleFavoriteAt(indexPath: indexPath)
    }
}
