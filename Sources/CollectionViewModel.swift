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

public struct CollectionViewModel {
    // MARK: Properties

    public let sections: [SectionViewModel]

    public var isEmpty: Bool {
        self.sections.isEmpty || !self.sections.contains { !$0.isEmpty }
    }

    // MARK: Init

    public init(sections: [SectionViewModel]) {
        self.sections = sections
    }

    // MARK: Subscripts

    public subscript (indexPath: IndexPath) -> AnyCellViewModel {
        precondition(indexPath.section < self.sections.count)
        precondition(indexPath.item < self.sections[indexPath.section].cellViewModels.count)
        return self.sections[indexPath.section].cellViewModels[indexPath.item]
    }
}
