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

    // TODO: should be optional if indexPath doesn't exist?
    public subscript (indexPath: IndexPath) -> AnyCellViewModel {
        self.sections[indexPath.section].cellViewModels[indexPath.item]
    }
}
