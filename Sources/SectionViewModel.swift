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

public struct SectionViewModel: DiffableViewModel {

    public let id: UniqueIdentifier

    public let cells: [AnyCellViewModel]

    public let header: AnySupplementaryViewModel?

    public let footer: AnySupplementaryViewModel?

    public let supplementaryViews: [AnySupplementaryViewModel]

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
        let all = cells.union(views).union(headerFooter)
        return all
    }

    public init<Header: SupplementaryHeaderViewModel, Footer: SupplementaryFooterViewModel>(
        id: UniqueIdentifier,
        cells: [AnyCellViewModel] = [],
        header: Header? = nil,
        footer: Footer? = nil,
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
        cells: [Cell] = [],
        header: Header? = nil,
        footer: Footer? = nil,
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
        if let anyHeader = anyHeader { precondition(anyHeader._isHeader) }
        if let anyFooter = anyFooter { precondition(anyFooter._isFooter) }
        precondition(anySupplementaryViews.allSatisfy { !$0._isHeader && !$0._isFooter })
        self.id = id
        self.cells = anyCells
        self.header = anyHeader
        self.footer = anyFooter
        self.supplementaryViews = anySupplementaryViews
    }
}

// MARK: Collection, RandomAccessCollection

extension SectionViewModel: Collection, RandomAccessCollection {
    /// :nodoc:
    public var count: Int {
        self.cells.count
    }

    /// :nodoc:
    public var isEmpty: Bool {
        self.cells.isEmpty
    }

    /// :nodoc:
    public var startIndex: Int {
        self.cells.startIndex
    }

    /// :nodoc:
    public var endIndex: Int {
        self.cells.endIndex
    }

    /// :nodoc:
    public subscript(position: Int) -> AnyCellViewModel {
        self.cells[position]
    }

    /// :nodoc:
    public func index(after i: Int) -> Int {
        self.cells.index(after: i)
    }
}
