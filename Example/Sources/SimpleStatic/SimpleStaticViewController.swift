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

final class SimpleStaticViewController: UICollectionViewController {

    lazy var driver = CollectionViewDriver(
        view: self.collectionView,
        layout: self.collectionViewLayout,
        cellEventCoordinator: nil
    )

    // MARK: Init

    init() {
        let layout = UICollectionViewCompositionalLayout.list(
            using: .init(appearance: .insetGrouped)
        )
        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let models = ColorModel.makeColors()

        let cellViewModels = models.map {
            ColorCellViewModelList(
                color: $0,
                contextMenuConfiguration: nil
            )
        }

        let section = SectionViewModel(id: "section", cells: cellViewModels)

        let collectionViewModel = CollectionViewModel(sections: [section])

        self.driver.viewModel = collectionViewModel
    }
}
