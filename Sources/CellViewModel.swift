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

    var shouldHighlight: Bool { get }

    var contextMenuConfiguration: UIContextMenuConfiguration? { get }

    func configure(cell: CellType)

    func didSelect(with coordinator: CellEventCoordinator?)
}

extension CellViewModel {
    public var shouldHighlight: Bool { true }

    public var contextMenuConfiguration: UIContextMenuConfiguration? { nil }

    public func didSelect(with coordinator: CellEventCoordinator?) {
        coordinator?.didSelectCell(viewModel: self)
    }
}

extension CellViewModel {
    /// The cell class for this view model.
    public var cellClass: AnyClass { CellType.self }

    /// A default reuse identifier for cell registration.
    /// Value defaults to the name of the class implementing the `CellViewModel` protocol.
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
        AnyCellViewModel(self)
    }

    public func dequeueAndConfigureCellFor(collectionView: UICollectionView, at indexPath: IndexPath) -> CellType {
        let cell = self.registration.dequeueViewFor(collectionView: collectionView, at: indexPath) as! CellType
        self.configure(cell: cell)
        return cell
    }
}

/// A type-erased cell view model.
@MainActor
public struct AnyCellViewModel: CellViewModel {
    // MARK: DiffableViewModel

    nonisolated public var id: UniqueIdentifier { self._id }

    // MARK: ViewRegistrationProvider

    public var registration: ViewRegistration { self._registration }

    // MARK: CellViewModel

    public typealias CellType = UICollectionViewCell

    public var shouldHighlight: Bool { self._shouldHighlight }

    public var contextMenuConfiguration: UIContextMenuConfiguration? { self._contextMenuConfiguration }

    public func configure(cell: UICollectionViewCell) {
        self._configure(cell)
    }

    public func didSelect(with coordinator: CellEventCoordinator?) {
        self._didSelect(coordinator)
    }

    // MARK: Private

    private let _viewModel: AnyHashable
    private let _id: UniqueIdentifier
    private let _registration: ViewRegistration
    private let _shouldHighlight: Bool
    private let _contextMenuConfiguration: UIContextMenuConfiguration?
    private let _configure: (CellType) -> Void
    private let _didSelect: (CellEventCoordinator?) -> Void

    // MARK: Init

    public init<T: CellViewModel>(_ viewModel: T) {
        self._viewModel = viewModel
        self._id = viewModel.id
        self._registration = viewModel.registration
        self._shouldHighlight = viewModel.shouldHighlight
        self._contextMenuConfiguration = viewModel.contextMenuConfiguration
        self._configure = { cell in
            precondition(cell is T.CellType, "Cell must be of type \(T.CellType.self). Found \(cell.self)")
            viewModel.configure(cell: cell as! T.CellType)
        }
        self._didSelect = { controller in
            viewModel.didSelect(with: controller)
        }
    }
}

extension AnyCellViewModel: Equatable {
    nonisolated public static func == (left: AnyCellViewModel, right: AnyCellViewModel) -> Bool {
        left._viewModel == right._viewModel
    }
}

extension AnyCellViewModel: Hashable {
    nonisolated public func hash(into hasher: inout Hasher) {
        self._viewModel.hash(into: &hasher)
    }
}
