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

import UIKit

/// Defines the kind of a supplementary view (i.e., a header or footer).
public enum SupplementaryViewKind: Equatable {

    /// A header view.
    case header

    /// A footer view.
    case footer

    init(collectionElementKind: String) {
        switch collectionElementKind {
        case UICollectionView.elementKindSectionHeader: self = .header
        case UICollectionView.elementKindSectionFooter: self = .footer
        default:
            fatalError("Unknown elementKindSection: \(collectionElementKind)")
        }
    }

    var collectionElementKind: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}
