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

public struct SectionViewModel {

    public let cellViewModels: [CellViewModel]

    public let headerViewModel: SupplementaryViewModel?

    public let footerViewModel: SupplementaryViewModel?

    public init(cells: [CellViewModel],
                header: SupplementaryViewModel? = nil,
                footer: SupplementaryViewModel? = nil) {
        self.cellViewModels = cells
        self.headerViewModel = header
        self.footerViewModel = footer
    }

    // TODO: get empty state correct
    // https://github.com/plangrid/ReactiveLists/issues/122
}

extension SectionViewModel {
    var headerTitle: String? {
        self.headerViewModel?.title
    }

    var footerTitle: String? {
        self.footerViewModel?.title
    }
}
