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

/// Describes a kind of supplementary view.
public typealias SupplementaryViewKind = String

/// Defines a view model that describes and configures a supplementary view in a collection.
@MainActor
public protocol SupplementaryViewModel: DiffableViewModel, ViewRegistrationProvider {
    /// The type of view that this view model represents and configures.
    associatedtype ViewType: UICollectionReusableView

    /// Configures the provided view for display in the collection.
    /// - Parameter cell: The view to configure.
    func configure(view: ViewType)
}

extension SupplementaryViewModel {
    /// The view class for this view model.
    public var viewClass: AnyClass { ViewType.self }

    /// A default reuse identifier for cell registration.
    /// Returns the name of the class implementing the `CellViewModel` protocol.
    public var reuseIdentifier: String { "\(Self.self)" }

    /// Returns a type-erased version of this view model.
    public func eraseToAnyViewModel() -> AnySupplementaryViewModel {
        AnySupplementaryViewModel(self)
    }

    // MARK: Internal

    var _kind: SupplementaryViewKind {
        precondition(
            self.registration.viewType.isSupplementary,
            "Inconsistency error. Expected supplementary view registration"
        )
        return self.registration.viewType.kind
    }

    var _isHeader: Bool { self._kind == UICollectionView.elementKindSectionHeader }

    var _isFooter: Bool { self._kind == UICollectionView.elementKindSectionFooter }

    func dequeueAndConfigureViewFor(collectionView: UICollectionView, at indexPath: IndexPath) -> ViewType {
        let view = self.registration.dequeueViewFor(collectionView: collectionView, at: indexPath) as! ViewType
        self.configure(view: view)
        return view
    }
}

/// A type-erased supplementary view model.
///
/// - Note: When providing supplementary views with mixed data types to a `SectionViewModel`,
/// it is necessary to convert them to `AnySupplementaryViewModel`.
@MainActor
public struct AnySupplementaryViewModel: SupplementaryViewModel {
    // MARK: DiffableViewModel

    /// :nodoc:
    nonisolated public var id: UniqueIdentifier { self._id }

    // MARK: ViewRegistrationProvider

    /// :nodoc:
    public var registration: ViewRegistration { self._registration }

    // MARK: SupplementaryViewModel

    /// :nodoc:
    public typealias ViewType = UICollectionReusableView

    /// :nodoc:
    public func configure(view: ViewType) {
        self._configure(view)
    }

    // MARK: Private

    private let _viewModel: AnyHashable
    private let _id: UniqueIdentifier
    private let _registration: ViewRegistration
    private let _configure: (ViewType) -> Void

    // MARK: Init

    /// Initializes an `AnySupplementaryViewModel` from the provided supplementary view model.
    ///
    /// - Parameter viewModel: The view model to type-erase.
    public init<T: SupplementaryViewModel>(_ viewModel: T) {
        self._viewModel = viewModel
        self._id = viewModel.id
        self._registration = viewModel.registration
        self._configure = { view in
            precondition(view is T.ViewType, "View must be of type \(T.ViewType.self). Found \(view.self)")
            viewModel.configure(view: view as! T.ViewType)
        }
    }
}

extension AnySupplementaryViewModel: Equatable {
    /// :nodoc:
    nonisolated public static func == (left: AnySupplementaryViewModel, right: AnySupplementaryViewModel) -> Bool {
        left._viewModel == right._viewModel
    }
}

extension AnySupplementaryViewModel: Hashable {
    /// :nodoc:
    nonisolated public func hash(into hasher: inout Hasher) {
        self._viewModel.hash(into: &hasher)
    }
}

extension AnySupplementaryViewModel: CustomDebugStringConvertible {
    /// :nodoc:
    nonisolated public var debugDescription: String {
        MainActor.assumeIsolated {
            "\(self._viewModel)"
        }
    }
}
