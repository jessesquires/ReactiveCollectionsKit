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

/// Defines a view model that describes and configures a footer view
/// for a section in the collection view.
public protocol SupplementaryFooterViewModel: SupplementaryViewModel {
    /// The collection view footer element kind.
    static var kind: SupplementaryViewKind { get }
}

extension SupplementaryFooterViewModel {
    /// Default implementation. Returns a section footer kind.
    public static var kind: SupplementaryViewKind {
        CollectionViewConstants.footerKind
    }

    /// A default registration for this footer view model for class-based views.
    ///
    /// - Warning: Does not work for nib-based views.
    public var registration: ViewRegistration {
        ViewRegistration(
            reuseIdentifier: self.reuseIdentifier,
            supplementaryViewClass: self.viewClass,
            kind: Self.kind
        )
    }
}
