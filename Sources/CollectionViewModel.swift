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

    // MARK: Accessing Cells and Supplementary Views

    public func cell(at indexPath: IndexPath) -> AnyCellViewModel {
        precondition(indexPath.section < self.sections.count)
        precondition(indexPath.item < self.sections[indexPath.section].cellViewModels.count)
        return self.sections[indexPath.section].cellViewModels[indexPath.item]
    }

    public func supplementaryView(ofKind kind: String, at indexPath: IndexPath) -> AnySupplementaryViewModel? {
        precondition(indexPath.section < self.sections.count)
        return self.sections[indexPath.section].supplementaryViewModels.first { $0.kind == kind }
    }

    // MARK: Subscripts

    public subscript (index: Int) -> SectionViewModel {
        precondition(index < self.sections.count)
        return self.sections[index]
    }
}
