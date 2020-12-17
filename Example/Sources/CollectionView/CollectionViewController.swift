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

final class CollectionViewController: UICollectionViewController {

    var driver: ContainerViewDriver<UICollectionView>!

    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ViewModel.makeCollectionViewModel(model: self.model)
        self.driver = ContainerViewDriver(
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

extension UICollectionView {
    func uniformCellSize() -> CGSize {
        let viewWidth = self.frame.size.width
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let insets = (sectionInset.left + sectionInset.right) * 2
        let size = (viewWidth - insets) / 2
        return CGSize(width: size, height: size)
    }
}
