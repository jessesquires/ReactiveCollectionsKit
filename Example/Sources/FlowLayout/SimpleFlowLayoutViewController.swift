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

final class SimpleFlowLayoutViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    lazy var driver = CollectionViewDriver(view: self.collectionView)

    // MARK: Init

    init() {
        let layout = UICollectionViewFlowLayout()
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

        self.driver.flowLayoutDelegate = self

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

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let random = Int.random(in: 70...200)
        return CGSize(width: random, height: random)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
}
