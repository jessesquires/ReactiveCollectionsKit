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

/// Defines a view model that describes and configures a cell in the collection view.
@MainActor
public protocol CellViewModel: DiffableViewModel, ViewRegistrationProvider {
    /// The type of cell that this view model represents and configures.
    associatedtype CellType: UICollectionViewCell

    /// Returns whether or not the cell should get highlighted.
    /// This corresponds to the delegate method `collectionView(_:shouldHighlightItemAt:)`.
    /// The default implementation returns `true`.
    var shouldHighlight: Bool { get }

    /// Returns a context menu configuration for the cell.
    /// This corresponds to the delegate method `collectionView(_:contextMenuConfigurationForItemAt:point:)`.
    var contextMenuConfiguration: UIContextMenuConfiguration? { get }

    /// Configures the provided cell for display in the collection.
    /// - Parameter cell: The cell to configure.
    func configure(cell: CellType)

    /// Handles the selection event for this cell, optionally using the provided `coordinator`.
    /// - Parameter coordinator: An event coordinator object, if one was provided to the `CollectionViewDriver`.
    func didSelect(with coordinator: CellEventCoordinator?)
}

extension CellViewModel {
    /// Default implementation. Returns `true`.
    public var shouldHighlight: Bool { true }

    /// Default implementation. Returns `nil`.
    public var contextMenuConfiguration: UIContextMenuConfiguration? { nil }

    /// Default implementation.
    /// Calls `didSelectCell(viewModel:)` on the `coordinator`,
    /// passing `self` to the `viewModel` parameter.
    public func didSelect(with coordinator: CellEventCoordinator?) {
        coordinator?.didSelectCell(viewModel: self)
    }
}

extension CellViewModel {
    /// The cell class for this view model.
    public var cellClass: AnyClass { CellType.self }

    /// A default reuse identifier for cell registration.
    /// Returns the name of the class implementing the `CellViewModel` protocol.
    public var reuseIdentifier: String { "\(Self.self)" }

    /// A default registration for this view model for class-based cells.
    /// - Warning: Does not work for nib-based cells.
    public var registration: ViewRegistration {
        ViewRegistration(
            reuseIdentifier: self.reuseIdentifier,
            cellClass: self.cellClass
        )
    }

    /// Returns a type-erased version of this view model.
    public func eraseToAnyViewModel() -> AnyCellViewModel {
        if let erasedViewModel = self as? AnyCellViewModel {
            return erasedViewModel
        } else {
            return AnyCellViewModel(self)
        }
    }

    // MARK: Internal

    func dequeueAndConfigureCellFor(collectionView: UICollectionView, at indexPath: IndexPath) -> CellType {
        let cell = self.registration.dequeueViewFor(collectionView: collectionView, at: indexPath) as! CellType
        self.configure(cell: cell)
        return cell
    }
}

/// A type-erased cell view model.
///
/// - Note: When providing cells with mixed data types to a `SectionViewModel`,
/// it is necessary to convert them to `AnyCellViewModel`.
@MainActor
public struct AnyCellViewModel: CellViewModel {
    // MARK: DiffableViewModel

    /// :nodoc:
    nonisolated public var id: UniqueIdentifier { self._id }

    // MARK: ViewRegistrationProvider

    /// :nodoc:
    public var registration: ViewRegistration { self._registration }

    // MARK: CellViewModel

    /// :nodoc:
    public typealias CellType = UICollectionViewCell

    /// :nodoc:
    public var shouldHighlight: Bool { self._shouldHighlight }

    /// :nodoc:
    public var contextMenuConfiguration: UIContextMenuConfiguration? { self._contextMenuConfiguration }

    /// :nodoc:
    public func configure(cell: UICollectionViewCell) {
        self._configure(cell)
    }

    /// :nodoc:
    public func didSelect(with coordinator: CellEventCoordinator?) {
        self._didSelect(coordinator)
    }

    /// :nodoc: "override" extension
    public let cellClass: AnyClass

    /// :nodoc: "override" extension
    public let reuseIdentifier: String

    // MARK: Private

    private let _viewModel: AnyHashable
    private let _id: UniqueIdentifier
    private let _registration: ViewRegistration
    private let _shouldHighlight: Bool
    private let _contextMenuConfiguration: UIContextMenuConfiguration?
    private let _configure: (CellType) -> Void
    private let _didSelect: (CellEventCoordinator?) -> Void

    // MARK: Init

    /// Initializes an `AnyCellViewModel` from the provided cell view model.
    ///
    /// - Parameter viewModel: The view model to type-erase.
    public init<T: CellViewModel>(_ viewModel: T) {
        if let erasedViewModel = viewModel as? AnyCellViewModel {
            self = erasedViewModel
            return
        }
        self._viewModel = viewModel
        self._id = viewModel.id
        self._registration = viewModel.registration
        self._shouldHighlight = viewModel.shouldHighlight
        self._contextMenuConfiguration = viewModel.contextMenuConfiguration
        self._configure = { cell in
            precondition(cell is T.CellType, "Cell must be of type \(T.CellType.self). Found \(cell.self)")
            viewModel.configure(cell: cell as! T.CellType)
        }
        self._didSelect = { coordinator in
            viewModel.didSelect(with: coordinator)
        }
        self.cellClass = viewModel.cellClass
        self.reuseIdentifier = viewModel.reuseIdentifier
    }
}

extension AnyCellViewModel: Equatable {
    /// :nodoc:
    nonisolated public static func == (left: AnyCellViewModel, right: AnyCellViewModel) -> Bool {
        left._viewModel == right._viewModel
    }
}

extension AnyCellViewModel: Hashable {
    /// :nodoc:
    nonisolated public func hash(into hasher: inout Hasher) {
        self._viewModel.hash(into: &hasher)
    }
}

extension AnyCellViewModel: CustomDebugStringConvertible {
    /// :nodoc:
    nonisolated public var debugDescription: String {
        MainActor.assumeIsolated {
            "\(self._viewModel)"
        }
    }
}
