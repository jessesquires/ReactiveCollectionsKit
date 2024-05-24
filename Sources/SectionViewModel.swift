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

/// Represents a section of items in a collection or list.
@MainActor
public struct SectionViewModel: DiffableViewModel {

    public let id: UniqueIdentifier

    public let cells: [AnyCellViewModel]

    public let header: AnySupplementaryViewModel?

    public let footer: AnySupplementaryViewModel?

    public let supplementaryViews: [AnySupplementaryViewModel]

    public var allSupplementaryViewsByIdentifier: [UniqueIdentifier: AnySupplementaryViewModel] {
        let tuples = self.supplementaryViews.map { ($0.id, $0) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }

    public var hasSupplementaryViews: Bool {
        self.header != nil
        || self.footer != nil
        || self.supplementaryViews.isNotEmpty
    }

    public var cellRegistrations: Set<ViewRegistration> {
        Set(self.cells.map { $0.registration })
    }

    public var headerFooterRegistrations: Set<ViewRegistration> {
        Set([self.header, self.footer].compactMap { $0?.registration })
    }

    public var supplementaryViewRegistrations: Set<ViewRegistration> {
        Set(self.supplementaryViews.map { $0.registration })
    }

    public var allRegistrations: Set<ViewRegistration> {
        let cells = self.cellRegistrations
        let headerFooter = self.headerFooterRegistrations
        let views = self.supplementaryViewRegistrations
        return cells.union(views).union(headerFooter)
    }

    public init(id: UniqueIdentifier, cells: [AnyCellViewModel] = []) {
        self.init(
            id: id,
            anyCells: cells,
            anyHeader: nil,
            anyFooter: nil,
            anySupplementaryViews: []
        )
    }

    public init<Cell: CellViewModel>(
        id: UniqueIdentifier,
        cells: [Cell]
    ) {
        self.init(
            id: id,
            anyCells: cells.map { $0.anyViewModel },
            anyHeader: nil,
            anyFooter: nil,
            anySupplementaryViews: []
        )
    }

    public init<Header: SupplementaryHeaderViewModel, Footer: SupplementaryFooterViewModel>(
        id: UniqueIdentifier,
        cells: [AnyCellViewModel] = [],
        header: Header?,
        footer: Footer?,
        supplementaryViews: [AnySupplementaryViewModel] = []
    ) {
        self.init(
            id: id,
            anyCells: cells,
            anyHeader: header?.anyViewModel,
            anyFooter: footer?.anyViewModel,
            anySupplementaryViews: supplementaryViews
        )
    }

    public init<Cell: CellViewModel, Header: SupplementaryHeaderViewModel, Footer: SupplementaryFooterViewModel>(
        id: UniqueIdentifier,
        cells: [Cell],
        header: Header?,
        footer: Footer?,
        supplementaryViews: [AnySupplementaryViewModel] = []
    ) {
        self.init(
            id: id,
            anyCells: cells.map { $0.anyViewModel },
            anyHeader: header?.anyViewModel,
            anyFooter: footer?.anyViewModel,
            anySupplementaryViews: supplementaryViews
        )
    }

    public init<Cell: CellViewModel,
                Header: SupplementaryHeaderViewModel,
                Footer: SupplementaryFooterViewModel,
                View: SupplementaryViewModel>(
        id: UniqueIdentifier,
        cells: [Cell],
        header: Header?,
        footer: Footer?,
        supplementaryViews: [View]
    ) {
        self.init(
            id: id,
            anyCells: cells.map { $0.anyViewModel },
            anyHeader: header?.anyViewModel,
            anyFooter: footer?.anyViewModel,
            anySupplementaryViews: supplementaryViews.map { $0.anyViewModel }
        )
    }

    private init(
        id: UniqueIdentifier,
        anyCells: [AnyCellViewModel],
        anyHeader: AnySupplementaryViewModel?,
        anyFooter: AnySupplementaryViewModel?,
        anySupplementaryViews: [AnySupplementaryViewModel]
    ) {
        if let anyHeader { precondition(anyHeader._isHeader) }
        if let anyFooter { precondition(anyFooter._isFooter) }
        precondition(anySupplementaryViews.allSatisfy { !$0._isHeader && !$0._isFooter })
        self.id = id
        self.cells = anyCells
        self.header = anyHeader
        self.footer = anyFooter
        self.supplementaryViews = anySupplementaryViews
    }

    func supplementaryViewsEqualTo(_ otherSection: Self) -> Bool {
        self.header == otherSection.header
        && self.footer == otherSection.footer
        && self.supplementaryViews == otherSection.supplementaryViews
    }
}

// MARK: Collection, RandomAccessCollection

extension SectionViewModel: Collection, RandomAccessCollection {
    /// :nodoc:
    nonisolated public var count: Int {
        MainActor.assumeIsolated {
            self.cells.count
        }
    }

    /// :nodoc:
    nonisolated public var isEmpty: Bool {
        MainActor.assumeIsolated {
            self.cells.isEmpty
        }
    }

    /// :nodoc:
    nonisolated public var startIndex: Int {
        MainActor.assumeIsolated {
            self.cells.startIndex
        }
    }

    /// :nodoc:
    nonisolated public var endIndex: Int {
        MainActor.assumeIsolated {
            self.cells.endIndex
        }
    }

    /// :nodoc:
    nonisolated public subscript(position: Int) -> AnyCellViewModel {
        MainActor.assumeIsolated {
            self.cells[position]
        }
    }

    /// :nodoc:
    nonisolated public func index(after pos: Int) -> Int {
        MainActor.assumeIsolated {
            self.cells.index(after: pos)
        }
    }
}
