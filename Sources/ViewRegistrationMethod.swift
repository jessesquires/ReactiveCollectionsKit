//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit

/// The method for registering cells and supplementary views.
public enum ViewRegistrationMethod {

    /// Class-based views.
    case fromClass(AnyClass)

    /// Nib-based views.
    case fromNib(name: String, bundle: Bundle?)

    var nib: UINib {
        switch self {
        case let .fromNib(name, bundle):
            return UINib(nibName: name, bundle: bundle)
        case .fromClass:
            fatalError("Attempt to access nib for class-based view")
        }
    }
}

extension ViewRegistrationMethod: Equatable {
    public static func == (lhs: ViewRegistrationMethod, rhs: ViewRegistrationMethod) -> Bool {
        switch (lhs, rhs) {
        case let (.fromClass(lhsClass), .fromClass(rhsClass)):
            return lhsClass == rhsClass
        case let (.fromNib(lhsName, lhsBundle), .fromNib(rhsName, rhsBundle)):
            return lhsName == rhsName && lhsBundle == rhsBundle
        default:
            return false
        }
    }
}
