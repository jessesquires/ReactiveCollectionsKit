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

/// A namespace for the actions for the `CellViewModel` protocol.
public enum CellActions {

    /// Describes a "did select" action for a cell.
    public typealias DidSelect = (UIViewController) -> Void

    /// A "no-op" `DidSelect` implementation. It does nothing.
    /// Use this in your `CellViewModel` conformance for cell view models that
    /// do not have a `DidSelect` action, since providing a `DidSelect` action is required.
    public static var DidSelectNoOperation: DidSelect { { _ in } }
}
