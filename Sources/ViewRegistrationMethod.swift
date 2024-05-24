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

/// The method by which to register a view for reuse in a `UICollectionView`.
public enum ViewRegistrationMethod: Hashable, Sendable {
    /// Registration for a class-based view.
    case viewClass(AnyClass)

    /// Registration for a nib-based view.
    case nib(name: String, bundle: Bundle?)

    private var _viewClassName: String? {
        switch self {
        case .viewClass(let anyClass): "\(anyClass)"
        case .nib: nil
        }
    }

    private var _nibName: String? {
        switch self {
        case .viewClass: nil
        case .nib(let name, _): name
        }
    }

    private var _nibBundle: Bundle? {
        switch self {
        case .viewClass: nil
        case .nib(_, let bundle): bundle
        }
    }

    // MARK: Equatable

    /// :nodoc:
    public static func == (left: Self, right: Self) -> Bool {
        left._viewClassName == right._viewClassName
        && left._nibName == right._nibName
        && left._nibBundle == right._nibBundle
    }

    // MARK: Hashable

    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self._viewClassName)
        hasher.combine(self._nibName)
        hasher.combine(self._nibBundle)
    }
}
