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

final class ContainerViewDataSource: NSObject {
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

extension ContainerViewDataSource: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension ContainerViewDataSource: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueAndConfigureCell(for: self.model, at: indexPath)
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
