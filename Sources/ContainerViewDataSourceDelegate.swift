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

final class ContainerViewDataSourceDelegate: NSObject {

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

extension ContainerViewDataSourceDelegate: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueAndConfigureCell(for: self.viewModel, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueAndConfigureSupplementaryView(for: SupplementaryViewKind(collectionElementKind: kind),
                                                            model: self.viewModel,
                                                            at: indexPath)!
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ContainerViewDataSourceDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel[indexPath].didSelect(controller)
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.viewModel[indexPath].shouldHighlight
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.viewModel[indexPath].size(in: collectionView)
    }
}

// MARK: UITableViewDelegate

extension ContainerViewDataSourceDelegate: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueAndConfigureCell(for: self.viewModel, at: indexPath)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.viewModel.sections[section].headerTitle
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        self.viewModel.sections[section].footerTitle
    }
}

// MARK: UITableViewDelegate

extension ContainerViewDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel[indexPath].didSelect(controller)
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        self.viewModel[indexPath].shouldHighlight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.viewModel[indexPath].size(in: tableView).height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.dequeueAndConfigureSupplementaryView(for: .header,
                                                       model: self.viewModel,
                                                       at: IndexPath(section: section))
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        tableView.dequeueAndConfigureSupplementaryView(for: .footer,
                                                       model: self.viewModel,
                                                       at: IndexPath(section: section))
    }
}

extension IndexPath {
    init(section: Int) {
        self.init(item: 0, section: section)
    }
}
