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
        precondition(indexPath.item < self[indexPath.section].cells.count)
        return self[indexPath.section].cells[indexPath.item]
    }

    public func supplementaryView(ofKind kind: String, at indexPath: IndexPath) -> AnySupplementaryViewModel? {
        precondition(indexPath.section < self.count)
        return self[indexPath.section].supplementaryViews.first { $0.kind == kind }
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
            text.append("\t cells: \n")
            for cellIndex in 0..<section.cells.count {
                let cellId = String(describing: section[cellIndex].id)
                text.append("\t\t[\(cellIndex)]: \(cellId) \n")
            }

            text.append("\t supplementary views: \n")
            for viewIndex in 0..<section.supplementaryViews.count {
                let view = section.supplementaryViews[viewIndex]
                text.append("\t\t[\(viewIndex)]: \(String(describing: view.id)) (\(String(describing: view.kind))) \n")
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
