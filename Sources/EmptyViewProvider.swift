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

/// Provides an "empty state" or "no content" view for the collection view.
@MainActor
public struct EmptyViewProvider {
    /// A closure that returns the view.
    public let viewBuilder: () -> UIView

    /// The empty view.
    public var view: UIView {
        viewBuilder()
    }

    /// Initializes an `EmptyViewProvider` with the given closure.
    ///
    /// - Parameter viewBuilder: A closure that creates and returns the empty view.
    public init(_ viewBuilder: @escaping () -> UIView) {
        self.viewBuilder = viewBuilder
    }
}
