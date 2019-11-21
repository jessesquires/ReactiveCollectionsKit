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

public enum CellActions {
    public typealias DidSelect = (UIViewController) -> Void

    /// A "no-op" `DidSelect` implementation.
    /// Use this in your `CellViewModel` conformance for cell view models that
    /// do not have a `DidSelect` action.
    public static var DidSelectNoOp: DidSelect { { _ in } }
}
