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

/// Describes a view model that is diffable.
public protocol DiffableViewModel: Hashable {

    /// An identifier that uniquely identifies this instance.
    var id: UniqueIdentifier { get }
}

// swiftlint:disable unavailable_function

extension DiffableViewModel {
    // TODO: use id for these?

    public static func == (left: Self, right: Self) -> Bool {
        preconditionFailure("\(self) must implement Equatable \(#function)")
    }

    public func hash(into hasher: inout Hasher) {
        preconditionFailure("\(self) must implement Hashable \(#function)")
    }
}

// swiftlint:enable unavailable_function
