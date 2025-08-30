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
import UIKit

/// Represents a collection view with sections and items.
public struct CollectionViewModel: DiffableViewModel {
    /// Returns the empty collection view model.
    public static var empty: Self {
        Self(id: "com.ReactiveCollectionsKit.CollectionViewModel.empty")
    }

    // MARK: DiffableViewModel

    /// A unique id for this model.
    public let id: UniqueIdentifier

    // MARK: Properties

    /// The sections in the collection.
    public let sections: [SectionViewModel]

    // MARK: Init

    /// Initializes a new ``CollectionViewModel``.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the collection.
    ///   - sections: The sections in the collection.
    public init(id: UniqueIdentifier, sections: [SectionViewModel] = []) {
        self.id = id
        self.sections = sections.filter(\.isNotEmpty)
    }

    // MARK: Accessing Sections

    /// Returns the section for the specified `id`.
    /// - Parameter id: The identifier for the section.
    /// - Returns: The section, if it exists.
    public func sectionViewModel(for id: UniqueIdentifier) -> SectionViewModel? {
        self.sections.first { $0.id == id }
    }

    ///  Returns the section at the specified index.
    ///
    /// - Parameter index: The index of the section.
    /// - Returns: The section at `index`.
    ///
    /// - Precondition: The specified `index` must be valid.
    public func sectionViewModel(at index: Int) -> SectionViewModel {
        precondition(index < self.count)
        return self.sections[index]
    }

    // MARK: Accessing Cells

    /// Returns the cell for the specified `id` by traversing each section and all of the children of each cell.
    ///
    /// - Parameter id: The identifier for the cell.
    /// - Returns: The cell, if it exists.
    public func cellViewModel(for id: UniqueIdentifier) -> AnyCellViewModel? {
        for section in self.sections {
            for cell in section.cells {
                if let foundViewModel = cellViewModel(in: cell, with: id) {
                    return foundViewModel
                }
            }
        }

        return nil
    }

    /// Returns the cell at the specified index path.
    ///
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: The cell at `indexPath`.
    ///
    /// - Precondition: The specified `indexPath` must be valid.
    public func cellViewModel(at indexPath: IndexPath, in collectionView: UICollectionView) -> AnyCellViewModel {
        precondition(indexPath.section < self.count)
        let section = self.sectionViewModel(at: indexPath.section)

        let cells = section.cells
        precondition(indexPath.item < cells.count)

        guard let diffableDataSource = collectionView.dataSource as? DiffableDataSource
        else {
            return cells[indexPath.item]
        }

        let snapshot = diffableDataSource.snapshot(for: section.id)
        let id = snapshot.visibleItems[indexPath.item]

        guard let cellViewModel = cellViewModel(for: id)
        else {
            return cells[indexPath.item]
        }

        return cellViewModel
    }

    /// Recursively traverse the children array of each child to locate a matching cell view model
    private func cellViewModel(in viewModel: AnyCellViewModel, with id: UniqueIdentifier) -> AnyCellViewModel? {
        if viewModel.id == id {
            return viewModel
        }

        for child in viewModel.children {
            if let foundChildViewModel = cellViewModel(in: child, with: id) {
                return foundChildViewModel
            }
        }

        return nil
    }

    // MARK: Accessing Supplementary Views

    /// Returns the supplementary view for the specified `id`.
    ///
    /// - Parameter id: The identifier for the supplementary view.
    /// - Returns: The supplementary view, if it exists.
    public func supplementaryViewModel(for id: UniqueIdentifier) -> AnySupplementaryViewModel? {
        for section in self.sections {
            for view in section.supplementaryViews where view.id == id {
                return view
            }
        }
        return nil
    }

    /// Returns the supplementary view for the specified kind and index path.
    /// - Parameters:
    ///   - kind: The kind of the supplementary view.
    ///   - indexPath: The index path for the view.
    /// - Returns: The supplementary view.
    ///
    /// - Precondition: The specified `indexPath` must be valid.
    public func supplementaryViewModel(ofKind kind: String, at indexPath: IndexPath) -> AnySupplementaryViewModel? {
        precondition(indexPath.section < self.count)
        let section = self.sectionViewModel(at: indexPath.section)

        if kind == section.header?._kind {
            return section.header
        }

        if kind == section.footer?._kind {
            return section.footer
        }

        let supplementaryViews = section.supplementaryViews.filter { $0._kind == kind }
        if indexPath.item < supplementaryViews.count {
            return supplementaryViews[indexPath.item]
        }

        return nil
    }

    // MARK: Subscript

    /// Returns the cell at the specified index path.
    ///
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: The cell at `indexPath`.
    ///
    /// - Precondition: The specified `indexPath` must be valid.
    public subscript(indexPath: IndexPath) -> AnyCellViewModel {
        self.sections[indexPath.section][indexPath.item]
    }

    /// Returns the cell at the specified indexes.
    ///
    /// - Parameter item: The item index of the cell.
    /// - Parameter section: The section index of the cell.
    /// - Returns: The cell at `item` and `section`.
    ///
    /// - Precondition: The specified indexes must be valid.
    public subscript(item item: Int, section section: Int) -> AnyCellViewModel {
        self.sections[section][item]
    }

    // MARK: Internal

    func _safeSectionViewModel(at index: Int) -> SectionViewModel? {
        guard index < self.count else {
            return nil
        }
        return self.sectionViewModel(at: index)
    }

    func _safeCellViewModel(at indexPath: IndexPath, in collectionView: UICollectionView) -> AnyCellViewModel? {
        guard let section = self._safeSectionViewModel(at: indexPath.section),
              indexPath.item < section.cells.count else {
            return nil
        }
        return self.cellViewModel(at: indexPath, in: collectionView)
    }

    func _safeSupplementaryViewModel(ofKind kind: String, at indexPath: IndexPath) -> AnySupplementaryViewModel? {
        guard let section = self._safeSectionViewModel(at: indexPath.section) else {
            return nil
        }

        if kind == section.header?._kind {
            return section.header
        }

        if kind == section.footer?._kind {
            return section.footer
        }

        let supplementaryViews = section.supplementaryViews.filter { $0._kind == kind }
        guard indexPath.item < supplementaryViews.count else {
            return nil
        }

        return self.supplementaryViewModel(ofKind: kind, at: indexPath)
    }

    func allRegistrations() -> Set<ViewRegistration> {
        var all = Set<ViewRegistration>()
        self.sections.forEach {
            all.formUnion($0.allRegistrations())
        }
        return all
    }

    func allCellRegistrations() -> Set<ViewRegistration> {
        var all = Set<ViewRegistration>()
        self.sections.forEach {
            all.formUnion($0.cellRegistrations())
        }
        return all
    }

    func allHeaderFooterRegistrations() -> Set<ViewRegistration> {
        var all = Set<ViewRegistration>()
        self.sections.forEach {
            all.formUnion($0.headerFooterRegistrations())
        }
        return all
    }

    func allSupplementaryViewRegistrations() -> Set<ViewRegistration> {
        var all = Set<ViewRegistration>()
        self.sections.forEach {
            all.formUnion($0.supplementaryViewRegistrations())
        }
        return all
    }

    func allSectionsByIdentifier() -> [UniqueIdentifier: SectionViewModel] {
        let tuples = self.sections.map { ($0.id, $0) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }

    func allCellsByIdentifier() -> [UniqueIdentifier: AnyCellViewModel] {
        let allCells = self.flatMap(\.cells)
        let tuples = allCells.map { ($0.id, $0) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }

    func allSupplementaryViewKinds() -> Set<String> {
        var allKinds = Set<String>()
        self.sections.forEach {
            if let header = $0.header {
                allKinds.insert(header.registration.viewType.kind)
            }
            if let footer = $0.footer {
                allKinds.insert(footer.registration.viewType.kind)
            }
            $0.supplementaryViews.forEach {
                allKinds.insert($0.registration.viewType.kind)
            }
        }
        return allKinds
    }
}

// MARK: Collection, RandomAccessCollection

extension CollectionViewModel: Collection, RandomAccessCollection {
    /// :nodoc:
    public var count: Int {
        self.sections.count
    }

    /// :nodoc:
    public var isEmpty: Bool {
        self.sections.isEmpty
    }

    /// :nodoc:
    public var startIndex: Int {
        self.sections.startIndex
    }

    /// :nodoc:
    public var endIndex: Int {
        self.sections.endIndex
    }

    /// :nodoc:
    public subscript(position: Int) -> SectionViewModel {
        self.sections[position]
    }

    /// :nodoc:
    public func index(after pos: Int) -> Int {
        self.sections.index(after: pos)
    }
}

extension CollectionViewModel: CustomDebugStringConvertible {
    /// :nodoc:
    public var debugDescription: String {
        collectionDebugDescription(self)
    }
}
