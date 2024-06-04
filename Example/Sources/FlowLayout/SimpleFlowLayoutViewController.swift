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

final class SimpleFlowLayoutViewController: UICollectionViewController {

    lazy var driver = CollectionViewDriver(view: self.collectionView)

    // MARK: Init

    init() {
        /// NOTE: you do not have access to `UICollectionViewDelegateFlowLayout`.
        /// Docs: https://developer.apple.com/documentation/uikit/uicollectionviewdelegateflowlayout
        /// You can only create basic flow layouts with fixed item sizes, spacing, etc.
        /// If you need more flexibility, use `UICollectionViewCompositionalLayout` instead.
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 110, height: 110)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        super.init(collectionViewLayout: layout)
        self.collectionView.alwaysBounceVertical = true
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

        let collectionViewModel = CollectionViewModel(id: "static_flow_layout", sections: [section])

        self.driver.update(viewModel: collectionViewModel)
    }
}
