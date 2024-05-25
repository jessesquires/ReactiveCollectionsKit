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

/// Provides registration information for a reusable view in a `UICollectionView`.
@MainActor
public protocol ViewRegistrationProvider {
    /// The view registration information.
    var registration: ViewRegistration { get }
}
