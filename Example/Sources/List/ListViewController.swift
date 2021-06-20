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

final class ListViewController: UICollectionViewController {
    var driver: CollectionViewDriver!

    var model = Model() {
        didSet {
            self.driver.viewModel = ViewModel.createList(from: self.model)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = .supplementary
            configuration.footerMode = .supplementary
            let section = NSCollectionLayoutSection.list(using: configuration,
                                                         layoutEnvironment: layoutEnvironment)
            return section
        }
        collectionView.collectionViewLayout = layout

        let viewModel = ViewModel.createList(from: self.model)

        self.driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: viewModel,
            controller: self,
            animateUpdates: true) {
            print("list did update!")
        }

        self.addShuffle(action: #selector(shuffle))
    }

    @objc
    func shuffle() {
        self.model.shuffle()
    }
}
