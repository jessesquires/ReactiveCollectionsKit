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

import ReactiveCollectionsKit
import UIKit

class ExampleViewController: UICollectionViewController {
    var driver: CollectionViewDriver!

    var model = Model()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addShuffleButton()
        self.addReloadButton()
    }

    // MARK: Actions

    @objc
    func shuffle() {
        self.model.shuffle()
    }

    func reload() {
        self.driver.reloadData()
    }

    func reset() {
        self.model = Model()
    }

    func deleteItem(id: UniqueIdentifier) {
        self.model.delete(id: id)
    }

    func toggleFavorite(id: UniqueIdentifier) {
        self.model.toggleFavorite(id: id)
    }

    // MARK: Helpers

    private func appendRightBarButton(_ item: UIBarButtonItem) {
        var items = self.navigationItem.rightBarButtonItems ?? []
        items.append(item)
        self.navigationItem.rightBarButtonItems = items
    }

    private func addShuffleButton() {
        let item = UIBarButtonItem(systemImage: "shuffle", target: self, action: #selector(shuffle))
        self.appendRightBarButton(item)
    }

    private func addReloadButton() {
        let reload = UIAction(title: "Reload") { [unowned self] _ in
            self.reload()
        }

        let reset = UIAction(title: "Reset", attributes: .destructive) { [unowned self] _ in
            self.reset()
        }

        let menu = UIMenu(children: [reload, reset])
        let item = UIBarButtonItem(systemItem: .refresh, primaryAction: nil, menu: menu)
        self.appendRightBarButton(item)
    }
}
