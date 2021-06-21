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

public protocol ViewRegistrationProvider {

    var reuseIdentifier: String { get }

    var nibName: String? { get }

    var nibBundle: Bundle? { get }

    var registration: ViewRegistration { get }
}

extension ViewRegistrationProvider {

    public var reuseIdentifier: String { "\(Self.self)" }

    public var nibName: String? { nil }

    public var nibBundle: Bundle? { nil }
}
