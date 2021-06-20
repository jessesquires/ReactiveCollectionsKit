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

    public let cellViewModels: [AnyCellViewModel]

    public let supplementaryViewModels: [AnySupplementaryViewModel]

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
        self.id = id
        self.cellViewModels = cells.map { AnyCellViewModel($0) }
        self.supplementaryViewModels = supplementaryViews.map { AnySupplementaryViewModel($0) }
    }
}

// MARK: Collection, RandomAccessCollection

extension SectionViewModel: Collection, RandomAccessCollection {
    /// :nodoc:
    public var count: Int {
        self.cellViewModels.count
    }

    /// :nodoc:
    public var isEmpty: Bool {
        self.cellViewModels.isEmpty
    }

    /// :nodoc:
    public var startIndex: Int {
        self.cellViewModels.startIndex
    }

    /// :nodoc:
    public var endIndex: Int {
        self.cellViewModels.endIndex
    }

    /// :nodoc:
    public subscript(position: Int) -> AnyCellViewModel {
        self.cellViewModels[position]
    }

    /// :nodoc:
    public func index(after i: Int) -> Int {
        self.cellViewModels.index(after: i)
    }
}
