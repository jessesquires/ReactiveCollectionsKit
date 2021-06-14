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

final class _ContainerViewDataSourceDelegate: NSObject {

    var viewModel: ContainerViewModel

    // avoiding a strong reference to prevent a retain cycle.
    // passed from the `ContainerViewDriver`, which the view controller must own.
    // thus, we know the controller must be alive so unowned is safe.
    unowned var controller: UIViewController

    init(viewModel: ContainerViewModel, controller: UIViewController) {
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

extension _ContainerViewDataSourceDelegate: UICollectionViewDataSource {
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

// MARK: UICollectionViewDelegateFlowLayout

extension _ContainerViewDataSourceDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel[indexPath].didSelect(indexPath, collectionView, self.controller)
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.viewModel[indexPath].shouldHighlight
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.viewModel[indexPath].size(in: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let header = self.viewModel.sections[section].headerViewModel else {
            return .zero
        }
        return header.size(in: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let footer = self.viewModel.sections[section].footerViewModel else {
            return .zero
        }
        return footer.size(in: collectionView)
    }
}
