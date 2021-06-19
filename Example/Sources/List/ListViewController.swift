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

    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout

        let viewModel = self.makeViewModel(from: self.model)

        self.driver = CollectionViewDriver(
            view: self.collectionView,
            viewModel: viewModel,
            controller: self,
            animateUpdates: true) {
            print("list did update!")
        }

        self.addShuffle(action: #selector(shuffle))
    }

    func makeViewModel(from model: Model) -> CollectionViewModel {
        let peopleCellViewModels = model.people.map { ListPersonCellViewModel(person: $0) }
        let peopleSection = SectionViewModel(id: "section_0_people",
                                             cells: peopleCellViewModels)

        let colorCellViewModels = model.colors.map { ListColorCellViewModel(color: $0) }
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
