//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit

final class ContainerViewDataSourceDelegate: NSObject {
    let model: ContainerViewModel

    init(model: ContainerViewModel) {
        self.model = model
    }

    func numberOfSections() -> Int {
        self.model.sections.count
    }

    func numberOfItems(in section: Int) -> Int {
        self.model.sections[section].cellViewModels.count
    }
}

#warning("TODO: context menus")

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

extension ContainerViewDataSourceDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.model[indexPath].didSelect()
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

    #warning("TODO: header/footer titles")
}

extension ContainerViewDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.model[indexPath].didSelect()
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
                                                       at: IndexPath(row: 0, section: section))
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        tableView.dequeueAndConfigureSupplementaryView(for: .footer,
                                                       model: self.model,
                                                       at: IndexPath(row: 0, section: section))
    }
}
