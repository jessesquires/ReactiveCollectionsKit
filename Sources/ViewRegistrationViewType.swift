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

public enum ViewRegistrationViewType: Hashable {
    case cell
    case supplementary(kind: String)

    var kind: String? {
        switch self {
        case .cell: nil
        case .supplementary(let kind): kind
        }
    }
}
