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
import UIKit

public struct CollectionViewModel: Equatable, Hashable {
    // MARK: Properties

    public let sections: [SectionViewModel]

    public var allRegistrations: Set<ViewRegistration> {
        var all = Set<ViewRegistration>()
        self.sections.forEach {
            all.formUnion($0.allRegistrations)
        }
        return all
    }

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

extension CollectionViewModel: CustomDebugStringConvertible {
    public var debugDescription: String {
        var text = "<CollectionViewModel:\n sections:\n"

        for sectionIndex in 0..<self.sections.count {
            let section = self.sections[sectionIndex]

            text.append("\t[\(sectionIndex)]: \(section.id)\n")
            text.append("\t isEmpty: \(section.isEmpty)\n")
            text.append("\t cells: \n")
            for cellIndex in 0..<section.count {
                let cellId = String(describing: section[cellIndex].id)
                text.append("\t\t[\(cellIndex)]: \(cellId) \n")
            }

            text.append("\t supplementary views: \n")
            for viewIndex in 0..<section.count {
                let view = section.supplementaryViewModels[viewIndex]
                text.append("\t\t[\(viewIndex)]: \(String(describing: view.id)) (\(String(describing: view.kind))) \n")
            }
        }

        text.append(" registrations: \n")
        self.allRegistrations.forEach {
            text.append("\t- \($0.reuseIdentifier)\n")
        }
        text.append(" isEmpty: \(self.isEmpty)\n")
        text.append(">")
        return text
    }
}
