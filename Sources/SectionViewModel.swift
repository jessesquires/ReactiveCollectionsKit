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

    public let cellViewModels: [CellViewModel]

    public let headerViewModel: SupplementaryViewModel?

    public let footerViewModel: SupplementaryViewModel?

    public init(id: UniqueIdentifier,
                cells: [CellViewModel],
                header: SupplementaryViewModel? = nil,
                footer: SupplementaryViewModel? = nil) {
        self.id = id
        self.cellViewModels = cells
        self.headerViewModel = header
        self.footerViewModel = footer
    }
}

extension SectionViewModel {
    var headerTitle: String? {
        self.headerViewModel?.title
    }

    var footerTitle: String? {
        self.footerViewModel?.title
    }
}

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
    public subscript(position: Int) -> CellViewModel {
        self.cellViewModels[position]
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
    public func index(after i: Int) -> Int {
        self.cellViewModels.index(after: i)
    }
}
