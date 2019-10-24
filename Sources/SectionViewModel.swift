//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
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
}

