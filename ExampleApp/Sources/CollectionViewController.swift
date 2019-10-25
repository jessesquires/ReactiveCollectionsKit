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

final class CollectionViewController: UICollectionViewController {

    var model: ContainerViewModel!
    var driver: ContainerViewDriver<UICollectionView>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .systemGray6

        self.model = ViewModel.makeCollectionViewModel(controller: self)
        self.driver = ContainerViewDriver(view: self.collectionView, model: self.model)

        self.driver.reloadData()
    }
}

extension UICollectionView {
    func uniformCellSize() -> CGSize {
        let viewWidth = self.frame.size.width
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let insets = (sectionInset.left + sectionInset.right) * 2
        let size = (viewWidth - insets) / 2
        return CGSize(width: size, height: size)
    }
}
