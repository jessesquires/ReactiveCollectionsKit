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
        let inset = CGFloat(2.5)

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
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout

        let viewModel = self.makeViewModel(from: self.model)

        self.driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: viewModel,
            controller: self,
            animateUpdates: true) {
            print("grid did update!")
        }

        self.addShuffle(action: #selector(shuffle))
    }

    func makeViewModel(from model: Model) -> CollectionViewModel {
        let peopleCellViewModels = model.people.map { GridPersonCellViewModel(person: $0) }
        let peopleSection = SectionViewModel(id: "section_0_people",
                                             cells: peopleCellViewModels)

        let colorCellViewModels = model.colors.map { GridColorCellViewModel(color: $0) }
        let colorSection = SectionViewModel(id: "section_1_colors",
                                            cells: colorCellViewModels)

        return CollectionViewModel(sections: [peopleSection, colorSection])
    }

    @objc
    func shuffle() {
        self.model.shuffle()
        self.driver.viewModel = self.makeViewModel(from: self.model)
    }
}
