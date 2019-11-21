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
    weak var containerController: UIViewController?
    var model: ContainerViewModel

    init(model: ContainerViewModel, containerController: UIViewController?) {
        self.model = model
        self.containerController = containerController
    }

    func numberOfSections() -> Int {
        self.model.sections.count
    }

    func numberOfItems(in section: Int) -> Int {
        self.model.sections[section].cellViewModels.count
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
        collectionView.dequeueAndConfigureCell(for: self.model, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueAndConfigureSupplementaryView(for: SupplementaryViewKind(collectionElementKind: kind),
                                                            model: self.model,
                                                            at: indexPath)!
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ContainerViewDataSourceDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let controller = self.containerController else { return }
        self.model[indexPath].didSelect(controller)
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.model[indexPath].shouldHighlight
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.model[indexPath].size(in: collectionView)
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
        tableView.dequeueAndConfigureCell(for: self.model, at: indexPath)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.model.sections[section].headerTitle
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        self.model.sections[section].footerTitle
    }
}

// MARK: UITableViewDelegate

extension ContainerViewDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = self.containerController else { return }
        self.model[indexPath].didSelect(controller)
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        self.model[indexPath].shouldHighlight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.model[indexPath].size(in: tableView).height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.dequeueAndConfigureSupplementaryView(for: .header,
                                                       model: self.model,
                                                       at: IndexPath(section: section))
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        tableView.dequeueAndConfigureSupplementaryView(for: .footer,
                                                       model: self.model,
                                                       at: IndexPath(section: section))
    }
}

extension IndexPath {
    init(section: Int) {
        self.init(item: 0, section: section)
    }
}
