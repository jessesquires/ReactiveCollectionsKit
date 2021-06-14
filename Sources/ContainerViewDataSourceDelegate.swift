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

import UIKit

final class CollectionViewDataSourceDelegate: NSObject {

    var viewModel: CollectionViewModel

    // avoiding a strong reference to prevent a retain cycle.
    // passed from the `CollectionViewDriver`, which the view controller must own.
    // thus, we know the controller must be alive so unowned is safe.
    unowned var controller: UIViewController

    init(viewModel: CollectionViewModel, controller: UIViewController) {
        self.viewModel = viewModel
        self.controller = controller
    }

    func numberOfSections() -> Int {
        self.viewModel.sections.count
    }

    func numberOfItems(in section: Int) -> Int {
        self.viewModel.sections[section].cellViewModels.count
    }
}

// MARK: UICollectionViewDataSource

extension CollectionViewDataSourceDelegate: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView._dequeueAndConfigureCell(for: self.viewModel, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView._dequeueAndConfigureSupplementaryView(for: SupplementaryViewKind(collectionElementKind: kind),
                                                             model: self.viewModel,
                                                             at: indexPath)!
    }
}

// MARK: UICollectionViewDelegate

extension CollectionViewDataSourceDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel[indexPath].didSelect(indexPath, collectionView, self.controller)
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.viewModel[indexPath].shouldHighlight
    }
}
