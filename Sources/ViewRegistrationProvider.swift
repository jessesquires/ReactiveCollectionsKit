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

/// Describes a type (like a cell view model) that provides
/// registration information for a particular view.
@MainActor
public protocol ViewRegistrationProvider {
    var registration: ViewRegistration { get }
}
