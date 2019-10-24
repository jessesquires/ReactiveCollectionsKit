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
import DiffableCollectionsKit

final class CollectionViewController: UICollectionViewController {

    let model = ViewModel.makeCollectionViewModel()

    lazy var driver = ContainerViewDriver(view: self.collectionView, model: self.model)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .systemGray6
        self.driver.reloadData()
    }
}
