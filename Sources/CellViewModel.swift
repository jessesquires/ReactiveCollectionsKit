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

import UIKit

/// Defines a view model that describes and configures a cell in the collection view.
public protocol CellViewModel: DiffableViewModel {
    associatedtype CellType: UICollectionViewCell

    var reuseIdentifier: String { get }

    var nib: UINib? { get }

    var shouldHighlight: Bool { get }

    func registerWith(collectionView: UICollectionView)

    func configure(cell: CellType, at indexPath: IndexPath)

    func didSelect(with controller: UIViewController)
}

extension CellViewModel {
    public var cellClass: AnyClass { CellType.self }

    public var reuseIdentifier: String { "\(Self.self)" }

    public var nib: UINib? { nil }

    public var shouldHighlight: Bool { true }

    public func registerWith(collectionView: UICollectionView) {
        if let nib = self.nib {
            collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
        } else {
            collectionView.register(self.cellClass, forCellWithReuseIdentifier: self.reuseIdentifier)
        }
    }

    public func dequeueAndConfigureCellFor(collectionView: UICollectionView, at indexPath: IndexPath) -> CellType {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! CellType
        self.configure(cell: cell, at: indexPath)
        return cell
    }

    public func didSelect(with controller: UIViewController) { }

    public func toAnyViewModel() -> AnyCellViewModel {
        AnyCellViewModel(self)
    }
}

/// A type-erased cell view model.
public struct AnyCellViewModel: CellViewModel {
    // MARK: DiffableViewModel

    public var id: UniqueIdentifier { self._id }

    // MARK: CellViewModel

    public typealias CellType = UICollectionViewCell

    public var reuseIdentifier: String { self._reuseIdentifier }

    public var nib: UINib? { self._nib }

    public var shouldHighlight: Bool { self._shouldHighlight }

    public func registerWith(collectionView: UICollectionView) {
        self._registration(collectionView)
    }

    public func configure(cell: UICollectionViewCell, at indexPath: IndexPath) {
        self._configuration(cell, indexPath)
    }

    public func didSelect(with controller: UIViewController) {
        self._didSelect(controller)
    }

    // MARK: Private

    private let _id: UniqueIdentifier
    private let _reuseIdentifier: String
    private let _nib: UINib?
    private let _shouldHighlight: Bool
    private let _registration: (UICollectionView) -> Void
    private let _configuration: (CellType, IndexPath) -> Void
    private let _didSelect: (UIViewController) -> Void

    // MARK: Init

    public init<T: CellViewModel>(_ viewModel: T) {
        self._id = viewModel.id
        self._reuseIdentifier = viewModel.reuseIdentifier
        self._nib = viewModel.nib
        self._shouldHighlight = viewModel.shouldHighlight
        self._registration = { collectionView in
            viewModel.registerWith(collectionView: collectionView)
        }
        self._configuration = { cell, indexPath in
            precondition(cell is T.CellType, "Cell must be of type \(T.CellType.self). Found \(cell.self)")
            viewModel.configure(cell: cell as! T.CellType, at: indexPath)
        }
        self._didSelect = { controller in
            viewModel.didSelect(with: controller)
        }
    }
}
