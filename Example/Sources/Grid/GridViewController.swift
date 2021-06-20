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

        let fractionalWidth = CGFloat(0.5)
        let inset = CGFloat(4)

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidth),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(fractionalWidth))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: 0, bottom: inset, trailing: 0)

        // Headers
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerItemSize,
            elementKind: HeaderViewModel.kind,
            alignment: .top
        )
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]

        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout

        let viewModel = ViewModel.createGrid(from: self.model)

        self.driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: viewModel,
            controller: self,
            animateUpdates: true) {
            print("grid did update!")
        }

        self.addShuffle(action: #selector(shuffle))
    }

    @objc
    func shuffle() {
        self.model.shuffle()
        self.driver.viewModel = ViewModel.createGrid(from: self.model)
    }
}
