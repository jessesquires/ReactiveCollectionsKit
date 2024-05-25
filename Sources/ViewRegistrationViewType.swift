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

/// Describes the type of view to be registered for reuse.
public enum ViewRegistrationViewType: Hashable, Sendable {
    /// Describes a cell.
    case cell

    /// Describes a supplementary view.
    case supplementary(kind: String)

    // MARK: Internal

    var kind: String {
        switch self {
        case .cell: "cell"
        case .supplementary(let kind): kind
        }
    }

    var isCell: Bool {
        switch self {
        case .cell: true
        case .supplementary: false
        }
    }

    var isSupplementary: Bool {
        switch self {
        case .cell: false
        case .supplementary: true
        }
    }
}
