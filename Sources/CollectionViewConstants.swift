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

/// HACK: unfortunately, these `UICollectionView` constants are marked as `@MainActor`.
///
/// They do not need to be `@MainActor` and do no introduce any race conditions.
/// So, we're using the raw string values instead.
enum CollectionViewConstants {
    /// The same value as `UICollectionView.elementKindSectionHeader`.
    static var headerKind: SupplementaryViewKind {
        "UICollectionElementKindSectionHeader"
    }

    /// The same value as `UICollectionView.elementKindSectionFooter`.
    static var footerKind: SupplementaryViewKind {
        "UICollectionElementKindSectionFooter"
    }
}
