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

// Reference
// https://stackoverflow.com/a/70545219/16485538

import Foundation
import UIKit

class FileBrowserViewController: UIViewController {
    enum Section { // We have one section
        case main
    }

    typealias Item = URL // The item we are working with is a URL

    typealias Cell = UICollectionViewListCell // The cell we are using is a list

    let directory = URL(fileURLWithPath: "/") // The directory we want to browse

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! // The data source

    var collectionView: UICollectionView! // The collection view

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the collection view with a list layout so it looks like a table view
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let config = UICollectionLayoutListConfiguration(appearance: .plain)
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        })

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)

        // Here is the code to create a cell. Replace `URL` by your own data type managed by your app
        let cellRegistration = UICollectionView.CellRegistration<Cell, Item> { cell, indexPath, url in
            var content = cell.defaultContentConfiguration()
            content.text = url.lastPathComponent + " " + "\(indexPath)"
            if Self.isDirectory(url) {
                cell.accessories = [.outlineDisclosure(options: .init(style: .header))] // Add this to expandable cells
            } else {
                cell.accessories = []
            }
            cell.contentConfiguration = content
        }

        // Create a data source. We pass our `Section` type that we created and `URL` since we are working with files here
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, url in
            // Create a cell with the block created above
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: url)
        })

        // Only expand directories
        dataSource.sectionSnapshotHandlers.shouldExpandItem = {
            Self.isDirectory($0)
        }

        // Only collapse directories
        dataSource.sectionSnapshotHandlers.shouldCollapseItem = {
            Self.isDirectory($0)
        }

        // When a directory will be expanded, fill the directory with its files
        dataSource.sectionSnapshotHandlers.willExpandItem = { [weak self] url in
            guard let self = self else {
                return
            }

            var snapshot = self.dataSource.snapshot(for: .main)
            let items = Self.listFiles(in: url)
            snapshot.append(items, to: url)
            self.dataSource.apply(snapshot, to: .main, animatingDifferences: true) {
                self.reconfigureVisibleItems()
            }
        }

        // When a directory is collapsed, clear its content to free memory
        dataSource.sectionSnapshotHandlers.willCollapseItem = { [weak self] url in
            guard let self = self else {
                return
            }

            var snapshot = self.dataSource.snapshot(for: .main)
            let items = snapshot.items.filter { snapshot.parent(of: $0) == url } // Delete all files that are in the collapsed directory
            snapshot.delete(items)
            self.dataSource.apply(snapshot, to: .main, animatingDifferences: true) {
                self.reconfigureVisibleItems()
            }
        }

        // Load the directory
        loadDirectory()
    }

    // Fill the collection view with the content of the directory
    func loadDirectory() {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let items = Self.listFiles(in: directory)
        snapshot.append(items)
        dataSource.apply(snapshot, to: .main, animatingDifferences: true, completion: nil)
    }

    // Reconfigure visible items to update the cell appearance
    func reconfigureVisibleItems() {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(dataSource.snapshot(for: .main).visibleItems)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    // Check if a URL is a directory
    static func isDirectory(_ url: URL, fileManager: FileManager = .default) -> Bool {
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
            return isDir.boolValue
        } else {
            return false
        }
    }

    // List all files in a directory
    static func listFiles(in directory: URL, fileManager: FileManager = .default) -> [URL] {
        var items = (try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])) ?? []
        items.sort(by: { $0.lastPathComponent < $1.lastPathComponent }) // Sort files by name
        return items
    }
}
