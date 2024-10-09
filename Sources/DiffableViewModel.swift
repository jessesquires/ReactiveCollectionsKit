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

/// The unique identifier type for a `DiffableViewModel`.
public typealias UniqueIdentifier = AnyHashable

/// Describes a view model that is uniquely identifiable and diffable.
public protocol DiffableViewModel: Identifiable, Hashable {
    /// An identifier that uniquely identifies this instance.
    var id: UniqueIdentifier { get }
}
