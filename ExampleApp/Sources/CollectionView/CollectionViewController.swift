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

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ViewModel.makeCollectionViewModel(controller: self)
        self.driver = ContainerViewDriver(view: self.collectionView,
                                          viewModel: viewModel,
                                          diffingQueue: .global(qos: .userInteractive),
                                          didUpdate: { print("collection finished update!") })

        self.addShuffle(action: #selector(shuffle))
    }

    @objc
    func shuffle() {
        self.driver.viewModel = ViewModel.makeCollectionViewModel(controller: self, shuffled: true)
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
