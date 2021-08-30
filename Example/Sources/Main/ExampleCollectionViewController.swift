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

class ExampleCollectionViewController: UICollectionViewController {
    var driver: CollectionViewDriver!

    var model = Model()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addShuffle()
        self.addReload()
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

    func deleteAt(indexPath: IndexPath) {
        self.model.deleteModelAt(indexPath: indexPath)
    }

    func toggleFavoriteAt(indexPath: IndexPath) {
        self.model.toggleFavoriteAt(indexPath: indexPath)
    }

    // MARK: Helpers

    private func appendRightBarButton(_ item: UIBarButtonItem) {
        var items = self.navigationItem.rightBarButtonItems ?? []
        items.append(item)
        self.navigationItem.rightBarButtonItems = items
    }

    private func addShuffle() {
        let item = UIBarButtonItem(systemImage: "shuffle", target: self, action: #selector(shuffle))
        self.appendRightBarButton(item)
    }

    private func addReload() {
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
