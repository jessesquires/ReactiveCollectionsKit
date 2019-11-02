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
public typealias UniqueIdentifier = String

/// Describes a view model that is diffable.
public protocol DiffableViewModel {

    /// An identifier that uniquely identifies this instance.
    var id: UniqueIdentifier { get }
}

extension DiffableViewModel {

    /// Default implementation. Uses type name.
    public var id: UniqueIdentifier {
        return String(describing: Self.self)
    }
}
