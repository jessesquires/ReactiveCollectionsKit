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

public struct ContainerViewModel {

    public let sections: [SectionViewModel]

    public init(sections: [SectionViewModel]) {
        self.sections = sections
    }

    public subscript (indexPath: IndexPath) -> CellViewModel {
        self.sections[indexPath.section].cellViewModels[indexPath.item]
    }
}
