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
    /// Specifies whether or not to perform diffing on a background queue.
    /// Pass `true` to perform diffing in the background,
    /// pass `false` to perform diffing on the main thread.
    public let diffOnBackgroundQueue: Bool

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
    ///   - diffOnBackgroundQueue: Whether or not to perform diffing on a background queue. Default is `false`.
    ///   - reloadDataOnReplacingViewModel: Whether or not to reload or diff during replacement. Default is `false`.
    public init(
        diffOnBackgroundQueue: Bool = false,
        reloadDataOnReplacingViewModel: Bool = false
    ) {
        self.diffOnBackgroundQueue = diffOnBackgroundQueue
        self.reloadDataOnReplacingViewModel = reloadDataOnReplacingViewModel
    }
}
