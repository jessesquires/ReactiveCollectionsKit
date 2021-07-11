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

public struct CollectionViewModel: Equatable, Hashable {
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

    // MARK: Init

    public init(sections: [SectionViewModel]) {
        self.sections = sections
    }

    // MARK: Accessing Cells and Supplementary Views

    public func cell(at indexPath: IndexPath) -> AnyCellViewModel {
        precondition(indexPath.section < self.count)
        let section = self[indexPath.section]

        let cells = section.cells
        precondition(indexPath.item < cells.count)

        return cells[indexPath.item]
    }

    public func supplementaryView(ofKind kind: String, at indexPath: IndexPath) -> AnySupplementaryViewModel? {
        precondition(indexPath.section < self.count)
        let section = self[indexPath.section]

        if kind == section.header?.kind {
            return section.header
        }

        if kind == section.footer?.kind {
            return section.footer
        }

        let supplementaryViews = section.supplementaryViews.filter { $0.kind == kind }
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
    public func index(after i: Int) -> Int {
        self.sections.index(after: i)
    }
}

extension CollectionViewModel: CustomDebugStringConvertible {
    /// :nodoc:
    public var debugDescription: String {
        var text = "<CollectionViewModel:\n sections:\n"

        for sectionIndex in 0..<self.count {
            let section = self[sectionIndex]

            text.append("\t[\(sectionIndex)]: \(section.id)\n")
            text.append("\t isEmpty: \(section.isEmpty)\n")
            text.append("\t header: \(String(describing: section.header?.id))\n")
            text.append("\t footer: \(String(describing: section.footer?.id))\n")
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
                let kind = String(describing: view.kind)
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
