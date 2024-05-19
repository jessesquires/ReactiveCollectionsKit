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
public struct CollectionViewModel: Hashable, DiffableViewModel {
    // MARK: DiffableViewModel

    public var id: UniqueIdentifier

    // MARK: Properties

    public let sections: [SectionViewModel]

    public var allRegistrations: Set<ViewRegistration> {
        var all = Set<ViewRegistration>()
        self.sections.forEach {
            all.formUnion($0.allRegistrations)
        }
        return all
    }

    public var allCellsByIdentifier: [UniqueIdentifier: AnyCellViewModel] {
        let allCells = self.flatMap { $0.cells }
        let tuples = allCells.map { ($0.id, $0) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }

    public var allSectionsByIdentifier: [UniqueIdentifier: SectionViewModel] {
        let tuples = self.sections.map { ($0.id, $0) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }

    // MARK: Init

    public init(id: UniqueIdentifier = UUID(), sections: [SectionViewModel] = []) {
        self.id = id
        self.sections = sections.filter { $0.isNotEmpty }
    }

    // MARK: Accessing Sections

    public func sectionViewModel(for id: UniqueIdentifier) -> SectionViewModel? {
        self.allSectionsByIdentifier[id]
    }

    // MARK: Accessing Cells

    public func cellViewModel(for id: UniqueIdentifier) -> AnyCellViewModel? {
        self.allCellsByIdentifier[id]
    }

    public func cellViewModel(at indexPath: IndexPath) -> AnyCellViewModel {
        precondition(indexPath.section < self.count)
        let section = self[indexPath.section]

        let cells = section.cells
        precondition(indexPath.item < cells.count)

        return cells[indexPath.item]
    }

    // MARK: Accessing Supplementary Views

    public func supplementaryViewModel(ofKind kind: String, at indexPath: IndexPath) -> AnySupplementaryViewModel? {
        precondition(indexPath.section < self.count)
        let section = self[indexPath.section]

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

// TODO: implement CustomDebugStringConvertible for Section, AnyCell, AnySupplementary etc.
// If _viewModel conforms, use that implementation

extension CollectionViewModel: CustomDebugStringConvertible {
    /// :nodoc:
    public var debugDescription: String {
        var text = "<CollectionViewModel:\n id: \(self.id)\n sections:\n"

        for sectionIndex in 0..<self.count {
            let section = self[sectionIndex]

            text.append("\t[\(sectionIndex)]: \(section.id)\n")
            text.append("\t isEmpty: \(section.isEmpty)\n")

            if let header = section.header {
                text.append("\t header: \(header.id) (\(header._kind))\n")
            } else {
                text.append("\t header: nil")
            }

            if let footer = section.footer {
                text.append("\t footer: \(footer.id) (\(footer._kind))\n")
            } else {
                text.append("\t footer: nil")
            }

            text.append("\t cells: \n")
            for cellIndex in 0..<section.cells.count {
                let cell = section[cellIndex]
                let cellId = String(describing: cell.id)
                let reuseId = String(describing: cell.registration.reuseIdentifier)
                text.append("\t\t[\(cellIndex)]: \(cellId) (\(reuseId)) \n")
            }

            text.append("\t supplementary views: \n")
            for viewIndex in 0..<section.supplementaryViews.count {
                let view = section.supplementaryViews[viewIndex]
                let viewId = String(describing: view.id)
                let kind = String(describing: view._kind)
                text.append("\t\t[\(viewIndex)]: \(viewId) (\(kind)) \n")
            }
        }

        text.append(" registrations: \n")
        self.allRegistrations.forEach {
            text.append("\t- \($0.reuseIdentifier)\n")
        }
        text.append(" isEmpty: \(self.isEmpty)\n")
        text.append(">")
        return text
    }
}
