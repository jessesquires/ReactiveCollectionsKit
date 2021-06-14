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

final class GridViewController: UICollectionViewController {

    var driver: CollectionViewDriver!

    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ViewModel.makeCollectionViewModel(model: self.model)
        self.driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: viewModel,
            controller: self,
            diffingQueue: .global(qos: .userInteractive)) {
            print("collection finished update!")
        }

        self.addShuffle(action: #selector(shuffle))
    }

    @objc
    func shuffle() {
        self.model = Model(shuffle: true)
        self.driver.viewModel = ViewModel.makeCollectionViewModel(model: self.model)
    }
}
