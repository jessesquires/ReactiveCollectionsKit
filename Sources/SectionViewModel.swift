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

    public let supplementaryViews: [AnySupplementaryViewModel]

    public var cellRegistrations: Set<ViewRegistration> {
        Set(self.cells.map { $0.registration })
    }

    public var supplementaryViewRegistrations: Set<ViewRegistration> {
        Set(self.supplementaryViews.map { $0.registration })
    }

    public var allRegistrations: Set<ViewRegistration> {
        let cells = self.cellRegistrations
        let views = self.supplementaryViewRegistrations
        let all = cells.union(views)
        return all
    }

    public init(id: UniqueIdentifier) {
        self.init(
            id: id,
            cells: [] as! [AnyCellViewModel],
            supplementaryViews: [] as! [AnySupplementaryViewModel]
        )
    }

    public init<T: CellViewModel>(id: UniqueIdentifier, cells: [T]) {
        self.init(
            id: id,
            cells: cells,
            supplementaryViews: [] as! [AnySupplementaryViewModel]
        )
    }

    public init<T: CellViewModel, U: SupplementaryViewModel>(
        id: UniqueIdentifier,
        cells: [T],
        supplementaryViews: [U]
    ) {
        self.init(
            id: id,
            anyCells: cells.map { AnyCellViewModel($0) },
            anySupplementaryViews: supplementaryViews.map { AnySupplementaryViewModel($0) }
        )
    }

    public init(
        id: UniqueIdentifier,
        anyCells: [AnyCellViewModel],
        anySupplementaryViews: [AnySupplementaryViewModel]
    ) {
        self.id = id
        self.cells = anyCells
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
