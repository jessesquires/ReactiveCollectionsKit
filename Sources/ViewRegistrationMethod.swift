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
    public static func == (left: ViewRegistrationMethod, right: ViewRegistrationMethod) -> Bool {
        switch (left, right) {
        case let (.fromClass(lhsClass), .fromClass(rhsClass)):
            return lhsClass == rhsClass
        case let (.fromNib(leftName, leftBundle), .fromNib(rightName, rightBundle)):
            return leftName == rightName && leftBundle == rightBundle
        default:
            return false
        }
    }
}
