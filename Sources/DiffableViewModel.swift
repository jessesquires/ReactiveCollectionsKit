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

/// Unique identifier for a `DiffableViewModel`.
public typealias UniqueIdentifier = String

public protocol DiffableViewModel {

    var id: UniqueIdentifier { get }
}

extension DiffableViewModel {

    /// Default implementation. Uses type name.
    public var id: UniqueIdentifier {
        return String(describing: Self.self)
    }
}
