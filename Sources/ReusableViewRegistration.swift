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

/// Describes the registration information for a cell or supplementary view.
public struct ReusableViewRegistration: Equatable {

    /// The reuse identifier for the view.
    public let reuseIdentifier: String

    /// The registration method for the view.
    public let method: ViewRegistrationMethod

    /// Initializes a class-based `ReusableViewRegistration` for the provided `classType`.
    ///
    /// - Note:
    /// The class name is used for `reuseIdentifier`.
    /// The `method` is set to `.fromClass`.
    ///
    /// - Parameter classType: The cell or supplementary view class.
    public init(classType: AnyClass) {
        self.reuseIdentifier = "\(classType)"
        self.method = .fromClass(classType)
    }

    /// Initializes a nib-based `ReusableViewRegistration` for the provided `nibType`.
    ///
    /// - Note:
    /// The class name is used for `reuseIdentifier`.
    /// The `method` is set to `.fromNib` using the class name and main bundle.
    ///
    /// - Parameter nibType: The cell or supplementary view class.
    public init(nibType: AnyClass) {
        self.init(classType: nibType, nibName: "\(nibType)")
    }

    /// Initializes a nib-based `ReusableViewRegistration` for the provided `classType`, `nibName`, and `bundle`.
    ///
    /// - Note:
    /// The class name is used for `reuseIdentifier`.
    /// The `method` is set to `.fromNib` using the provided `nibName` and `bundle`.
    ///
    /// - Parameter classType: The cell or supplementary view class.
    /// - Parameter nibName: The name of the nib for the view.
    /// - Parameter bundle: The bundle in which the nib is located. Pass `nil` to use the main bundle.
    public init(classType: AnyClass, nibName: String, bundle: Bundle? = nil) {
        self.reuseIdentifier = "\(classType)"
        self.method = .fromNib(name: nibName, bundle: bundle)
    }
}
