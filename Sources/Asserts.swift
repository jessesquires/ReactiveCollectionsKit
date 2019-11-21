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

/// Asserts that execution is on the main thread.
/// - Parameter function: The calling function.
func _assertMainThread(_ function: String = #function) {
    assert(Thread.isMainThread, "*** \(function) must be called on main thread only")
}
