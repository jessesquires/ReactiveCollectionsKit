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
import ReactiveCollectionsKit
import UIKit

final class SimpleStaticViewController: UICollectionViewController, CellEventCoordinator {

    var driver: CollectionViewDriver!

    override func viewDidLoad() {
        super.viewDidLoad()

        let models = ColorModel.makeColors()

        let cellViewModels = models.map {
            ColorCellViewModelList(
                color: $0,
                contextMenuConfiguration: nil
            )
        }

        let section = SectionViewModel(id: "section_1", cells: cellViewModels)

        let collectionViewModel = CollectionViewModel(sections: [section])

        let layout = UICollectionViewCompositionalLayout.list(
            using: .init(appearance: .insetGrouped)
        )

        self.driver = CollectionViewDriver(
            view: self.collectionView,
            layout: layout,
            viewModel: collectionViewModel,
            cellEventCoordinator: self
        )
    }

    // MARK: CellEventCoordinator

    func didSelectCell(viewModel: any CellViewModel) {
        // TODO:
    }
}
