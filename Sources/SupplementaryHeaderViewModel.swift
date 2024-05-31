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

/// Defines a view model that describes and configures a header view
/// for a section in the collection view.
@MainActor
public protocol SupplementaryHeaderViewModel: SupplementaryViewModel {
    /// The collection view header element kind.
    static var kind: SupplementaryViewKind { get }
}

extension SupplementaryHeaderViewModel {
    /// Default implementation. Returns a section header kind.
    public static var kind: SupplementaryViewKind {
        UICollectionView.elementKindSectionHeader
    }
    /// A default registration for this header view model for class-based views.
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
