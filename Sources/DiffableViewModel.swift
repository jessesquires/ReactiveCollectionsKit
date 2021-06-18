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

    /// A default identifier that uses the conforming type's name.
    /// You may wish to use this in your `CellViewModel` if it is sufficient for your purposes.
    public var defaultId: UniqueIdentifier {
        String(describing: Self.self)
    }
}
