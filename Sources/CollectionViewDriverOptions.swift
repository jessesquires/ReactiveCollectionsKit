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

/// Defines various options to customize behavior of a ``CollectionViewDriver``.
public struct CollectionViewDriverOptions: Hashable {
    /// Specifies whether or not the ``CollectionViewDriver`` should
    /// perform a hard `reloadData()` when replacing the ``CollectionViewModel`` with
    /// a new one, or if it should always perform a diff.
    ///
    /// A replacement occurs when providing a new ``CollectionViewModel`` to the
    /// ``CollectionViewDriver`` that has a **different** `id` than the previous model.
    public let reloadDataOnReplacingViewModel: Bool

    /// Initializes a `CollectionViewDriverOptions` object.
    ///
    /// - Parameters:
    ///   - reloadDataOnReplacingViewModel: Whether or not to reload or diff during replacement. Default is `false`.
    public init(
        reloadDataOnReplacingViewModel: Bool = false
    ) {
        self.reloadDataOnReplacingViewModel = reloadDataOnReplacingViewModel
    }
}

extension CollectionViewDriverOptions: CustomDebugStringConvertible {
    public var debugDescription: String {
        driverOptionsDebugDescription(self)
    }
}
