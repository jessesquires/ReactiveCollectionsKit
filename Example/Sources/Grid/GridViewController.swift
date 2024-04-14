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

final class GridViewController: ExampleCollectionViewController {

    override var model: Model {
        didSet {
            self.driver.viewModel = self.createCollectionViewModel(style: .grid)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let fractionalWidth = CGFloat(0.5)
        let inset = CGFloat(4)

        // Supplementary Item
        let offset = 0.15
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: offset, y: -offset))
        let dimension = NSCollectionLayoutDimension.absolute(30)
        let badgeSize = NSCollectionLayoutSize(widthDimension: dimension, heightDimension: dimension)
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                        elementKind: FavoriteBadgeViewModel.kind,
                                                        containerAnchor: badgeAnchor)

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidth),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(fractionalWidth))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Headers and Footers
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(50))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: HeaderViewModel.kind,
                                                                        alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: FooterViewModel.kind,
                                                                        alignment: .bottom)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        let layout = UICollectionViewCompositionalLayout(section: section)

        let viewModel = self.createCollectionViewModel(style: .grid)

        self.driver = CollectionViewDriver(
            view: self.collectionView,
            layout: layout,
            viewModel: viewModel,
            cellEventCoordinator: self,
            animateUpdates: true) {
            print("grid did update!")
            print(self.driver.viewModel)
        }
    }
}
