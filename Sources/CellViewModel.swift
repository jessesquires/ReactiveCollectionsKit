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
public protocol CellViewModel: DiffableViewModel, ViewRegistrationProvider {
    /// The type of cell that this view model represents and configures.
    associatedtype CellType: UICollectionViewCell

    /// Returns whether or not the cell should get selected.
    /// This corresponds to the delegate method `collectionView(_:shouldSelectItemAt:)`.
    /// The default implementation returns `true`.
    var shouldSelect: Bool { get }

    /// Returns whether or not the cell should get deselected.
    /// This corresponds to the delegate method `collectionView(_:shouldDeselectItemAt:)`.
    /// The default implementation returns `true`.
    var shouldDeselect: Bool { get }

    /// Returns whether or not the cell should get highlighted.
    /// This corresponds to the delegate method `collectionView(_:shouldHighlightItemAt:)`.
    /// The default implementation returns `true`.
    var shouldHighlight: Bool { get }

    /// Returns a context menu configuration for the cell.
    /// This corresponds to the delegate method `collectionView(_:contextMenuConfigurationForItemAt:point:)`.
    var contextMenuConfiguration: UIContextMenuConfiguration? { get }

    /// Configures the provided cell for display in the collection.
    /// - Parameter cell: The cell to configure.
    @MainActor
    func configure(cell: CellType)

    /// Tells the view model that its cell was selected.
    ///
    /// Implement this method to handle this event, optionally using the provided `coordinator`.
    ///
    /// - Parameter coordinator: An event coordinator object, if one was provided to the `CollectionViewDriver`.
    @MainActor
    func didSelect(with coordinator: CellEventCoordinator?)

    /// Tells the view model that its cell was deselected.
    ///
    /// Implement this method to handle this event, optionally using the provided `coordinator`.
    ///
    /// - Parameter coordinator: An event coordinator object, if one was provided to the `CollectionViewDriver`.
    @MainActor
    func didDeselect(with coordinator: CellEventCoordinator?)

    /// Tells the view model that its cell is about to be displayed in the collection view.
    /// This corresponds to the delegate method `collectionView(_:willDisplay:forItemAt:)`.
    @MainActor
    func willDisplay()

    /// Tells the view model that its cell was removed from the collection view.
    /// This corresponds to the delegate method `collectionView(_:didEndDisplaying:forItemAt:)`.
    @MainActor
    func didEndDisplaying()

    /// Tells the view model that its cell was highlighted.
    /// This corresponds to the delegate method `collectionView(_:didHighlightItemAt:)`.
    @MainActor
    func didHighlight()

    /// Tells the view model that the highlight was removed from its cell.
    /// This corresponds to the delegate method `collectionView(_:didUnhighlightItemAt:)`.
    @MainActor
    func didUnhighlight()
}

extension CellViewModel {
    /// Default implementation. Returns `true`.
    public var shouldSelect: Bool { true }

    /// Default implementation. Returns `true`.
    public var shouldDeselect: Bool { true }

    /// Default implementation. Returns `true`.
    public var shouldHighlight: Bool { true }

    /// Default implementation. Returns `nil`.
    public var contextMenuConfiguration: UIContextMenuConfiguration? { nil }

    /// Default implementation.
    /// Calls `didSelectCell(viewModel:)` on the `coordinator`,
    /// passing `self` to the `viewModel` parameter.
    @MainActor
    public func didSelect(with coordinator: CellEventCoordinator?) {
        coordinator?.didSelectCell(viewModel: self)
    }

    /// Default implementation.
    /// Calls `didDeselectCell(viewModel:)` on the `coordinator`,
    /// passing `self` to the `viewModel` parameter.
    @MainActor
    public func didDeselect(with coordinator: CellEventCoordinator?) {
        coordinator?.didDeselectCell(viewModel: self)
    }

    /// Default implementation. Does nothing.
    @MainActor
    public func willDisplay() { }

    /// Default implementation. Does nothing.
    @MainActor
    public func didEndDisplaying() { }

    /// Default implementation. Does nothing.
    @MainActor
    public func didHighlight() { }

    /// Default implementation. Does nothing.
    @MainActor
    public func didUnhighlight() { }

    // MARK: Internal

    @MainActor
    func _configureGeneric(cell: UICollectionViewCell) {
        precondition(cell is CellType, "Cell must be of type \(CellType.self). Found \(cell.self)")
        self.configure(cell: cell as! CellType)
    }
}

extension CellViewModel {
    /// The cell class for this view model.
    public var cellClass: AnyClass { CellType.self }

    /// A default reuse identifier for cell registration.
    /// Returns the fully qualified type name (module name + class name) of the class implementing the `CellViewModel` protocol.
    public var reuseIdentifier: String { String(reflecting: Self.self) }

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
        }
        return AnyCellViewModel(self)
    }

    // MARK: Internal

    @MainActor
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
public struct AnyCellViewModel: CellViewModel {
    // MARK: DiffableViewModel

    /// :nodoc:
    public var id: UniqueIdentifier { self._id }

    // MARK: ViewRegistrationProvider

    /// :nodoc:
    public var registration: ViewRegistration { self._registration }

    // MARK: CellViewModel

    /// :nodoc:
    public typealias CellType = UICollectionViewCell

    /// :nodoc:
    public var shouldSelect: Bool { self._shouldSelect }

    /// :nodoc:
    public var shouldDeselect: Bool { self._shouldDeselect }

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

    /// :nodoc:
    public func didDeselect(with coordinator: CellEventCoordinator?) {
        self._didDeselect(coordinator)
    }

    /// :nodoc:
    public func willDisplay() {
        self._willDisplay()
    }

    /// :nodoc:
    public func didEndDisplaying() {
        self._didEndDisplaying()
    }

    /// :nodoc:
    public func didHighlight() {
        self._didHighlight()
    }

    /// :nodoc:
    public func didUnhighlight() {
        self._didUnhighlight()
    }

    /// :nodoc: "override" the extension
    public let cellClass: AnyClass

    /// :nodoc: "override" the extension
    public let reuseIdentifier: String

    // MARK: Private

    private let _viewModel: AnyHashable
    private let _id: UniqueIdentifier
    private let _registration: ViewRegistration
    private let _shouldSelect: Bool
    private let _shouldDeselect: Bool
    private let _shouldHighlight: Bool
    private let _contextMenuConfiguration: UIContextMenuConfiguration?
    private let _configure: @Sendable @MainActor (CellType) -> Void
    private let _didSelect: @Sendable @MainActor (CellEventCoordinator?) -> Void
    private let _didDeselect: @Sendable @MainActor (CellEventCoordinator?) -> Void
    private let _willDisplay: @Sendable @MainActor () -> Void
    private let _didEndDisplaying: @Sendable @MainActor () -> Void
    private let _didHighlight: @Sendable @MainActor() -> Void
    private let _didUnhighlight: @Sendable @MainActor () -> Void

    // MARK: Init

    /// Initializes an `AnyCellViewModel` from the provided cell view model.
    ///
    /// - Parameter viewModel: The view model to type-erase.
    public init<T: CellViewModel>(_ viewModel: T) {
        // prevent "double" / "nested" erasure
        if let erasedViewModel = viewModel as? Self {
            self = erasedViewModel
            return
        }
        self._viewModel = viewModel
        self._id = viewModel.id
        self._registration = viewModel.registration
        self._shouldSelect = viewModel.shouldSelect
        self._shouldDeselect = viewModel.shouldDeselect
        self._shouldHighlight = viewModel.shouldHighlight
        self._contextMenuConfiguration = viewModel.contextMenuConfiguration
        self._configure = {
            viewModel._configureGeneric(cell: $0)
        }
        self._didSelect = {
            viewModel.didSelect(with: $0)
        }
        self._didDeselect = {
            viewModel.didDeselect(with: $0)
        }
        self._willDisplay = {
            viewModel.willDisplay()
        }
        self._didEndDisplaying = {
            viewModel.didEndDisplaying()
        }
        self._didHighlight = {
            viewModel.didHighlight()
        }
        self._didUnhighlight = {
            viewModel.didUnhighlight()
        }
        self.cellClass = viewModel.cellClass
        self.reuseIdentifier = viewModel.reuseIdentifier
    }
}

extension AnyCellViewModel: Equatable {
    /// :nodoc:
    public static func == (left: AnyCellViewModel, right: AnyCellViewModel) -> Bool {
        left._viewModel == right._viewModel
    }
}

extension AnyCellViewModel: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        self._viewModel.hash(into: &hasher)
    }
}

extension AnyCellViewModel: CustomDebugStringConvertible {
    /// :nodoc:
    public var debugDescription: String {
        "\(self._viewModel)"
    }
}
