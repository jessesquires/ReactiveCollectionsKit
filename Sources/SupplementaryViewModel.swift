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
public protocol SupplementaryViewModel: DiffableViewModel, ViewRegistrationProvider {
    /// The type of view that this view model represents and configures.
    associatedtype ViewType: UICollectionReusableView

    /// Configures the provided view for display in the collection.
    /// - Parameter view: The view to configure.
    @MainActor
    func configure(view: ViewType)

    /// Tells the view model that its supplementary view is about to be displayed in the collection view.
    /// This corresponds to the delegate method `collectionView(_:willDisplaySupplementaryView:forElementKind:at:)`.
    @MainActor
    func willDisplay()

    /// Tells the view model that its supplementary view was removed from the collection view.
    /// This corresponds to the delegate method `collectionView(_:didEndDisplayingSupplementaryView:forElementOfKind:at:)`.
    @MainActor
    func didEndDisplaying()
}

extension SupplementaryViewModel {
    /// Default implementation. Does nothing.
    @MainActor
    public func willDisplay() { }

    /// Default implementation. Does nothing.
    @MainActor
    public func didEndDisplaying() { }

    // MARK: Internal

    @MainActor
    func _configureGeneric(view: UICollectionReusableView) {
        precondition(view is ViewType, "View must be of type \(ViewType.self). Found \(view.self)")
        self.configure(view: view as! ViewType)
    }
}

extension SupplementaryViewModel {
    /// The view class for this view model.
    public var viewClass: AnyClass { ViewType.self }

    /// A default reuse identifier for cell registration.
    /// Returns the name of the class implementing the `CellViewModel` protocol.
    public var reuseIdentifier: String { "\(Self.self)" }

    /// Returns a type-erased version of this view model.
    public func eraseToAnyViewModel() -> AnySupplementaryViewModel {
        if let erasedViewModel = self as? AnySupplementaryViewModel {
            return erasedViewModel
        }
        return AnySupplementaryViewModel(self)
    }

    // MARK: Internal

    var _kind: SupplementaryViewKind {
        precondition(
            self.registration.viewType.isSupplementary,
            "Inconsistency error. Expected supplementary view registration"
        )
        return self.registration.viewType.kind
    }

    @MainActor
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
public struct AnySupplementaryViewModel: SupplementaryViewModel {
    // MARK: DiffableViewModel

    /// :nodoc:
    public var id: UniqueIdentifier { self._id }

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

    /// :nodoc:
    public func willDisplay() {
        self._willDisplay()
    }

    /// :nodoc:
    public func didEndDisplaying() {
        self._didEndDisplaying()
    }

    /// :nodoc: "override" the extension
    public let viewClass: AnyClass

    /// :nodoc: "override" the extension
    public let reuseIdentifier: String

    // MARK: Internal

    var isHeader: Bool {
        self._registration.viewType.isHeader
    }

    var isFooter: Bool {
        self._registration.viewType.isFooter
    }

    var isOtherSupplementaryView: Bool {
        !self.isHeader && !self.isFooter
    }

    // MARK: Private

    private let _viewModel: AnyHashable
    private let _id: UniqueIdentifier
    private let _registration: ViewRegistration
    private let _configure: @Sendable @MainActor (ViewType) -> Void
    private let _willDisplay: @Sendable @MainActor () -> Void
    private let _didEndDisplaying: @Sendable @MainActor () -> Void

    // MARK: Init

    /// Initializes an `AnySupplementaryViewModel` from the provided supplementary view model.
    ///
    /// - Parameter viewModel: The view model to type-erase.
    public init<T: SupplementaryViewModel>(_ viewModel: T) {
        // prevent "double" / "nested" erasure
        if let erasedViewModel = viewModel as? Self {
            self = erasedViewModel
            return
        }
        self._viewModel = viewModel
        self._id = viewModel.id
        self._registration = viewModel.registration
        self._configure = {
            viewModel._configureGeneric(view: $0)
        }
        self._willDisplay = {
            viewModel.willDisplay()
        }
        self._didEndDisplaying = {
            viewModel.didEndDisplaying()
        }
        self.viewClass = viewModel.viewClass
        self.reuseIdentifier = viewModel.reuseIdentifier
    }
}

extension AnySupplementaryViewModel: Equatable {
    /// :nodoc:
    public static func == (left: AnySupplementaryViewModel, right: AnySupplementaryViewModel) -> Bool {
        left._viewModel == right._viewModel
    }
}

extension AnySupplementaryViewModel: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        self._viewModel.hash(into: &hasher)
    }
}

extension AnySupplementaryViewModel: CustomDebugStringConvertible {
    /// :nodoc:
    public var debugDescription: String {
        "\(self._viewModel)"
    }
}
