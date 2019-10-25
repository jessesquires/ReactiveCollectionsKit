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

public struct ContainerViewModel {

    public let sections: [SectionViewModel]

    public var isEmpty: Bool {
        self.sections.isEmpty || !self.sections.contains { !$0.isEmpty }
    }

    public init(sections: [SectionViewModel]) {
        self.sections = sections
    }

    public subscript (indexPath: IndexPath) -> CellViewModel {
        self.sections[indexPath.section].cellViewModels[indexPath.item]
    }
}
