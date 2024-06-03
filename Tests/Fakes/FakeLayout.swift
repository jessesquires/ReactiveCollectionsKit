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

import Foundation
@testable import ReactiveCollectionsKit
import UIKit

extension UICollectionViewCompositionalLayout {
    static func fakeLayout() -> UICollectionViewCompositionalLayout {
        let fractionalWidth = CGFloat(0.5)

        // Supplementary Item
        let viewSize = NSCollectionLayoutSize(widthDimension: .absolute(50),
                                              heightDimension: .absolute(50))
        let view = NSCollectionLayoutSupplementaryItem(layoutSize: viewSize,
                                                       elementKind: FakeSupplementaryViewModel.kind,
                                                       containerAnchor: .init(edges: .top))

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidth),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [view])

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(fractionalWidth))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Headers and Footers
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: FakeHeaderViewModel.kind,
                                                                        alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: FakeFooterViewModel.kind,
                                                                        alignment: .bottom)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        return UICollectionViewCompositionalLayout(section: section)
    }
}
