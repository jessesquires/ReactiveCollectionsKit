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

    public var isEmpty: Bool {
        self.cellViewModels.isEmpty
            && self.headerViewModel == nil
            && self.footerViewModel == nil
    }

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
