//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit

/// This protocol unifies `UICollectionView` and `UITableView` with a common interface
/// for dequeuing and registering cells and supplementary views.
///
/// It describes a view that is the "container" view for a cell or supplementary view.
/// For `UICollectionViewCell`, this would be `UICollectionView`.
/// For `UITableViewCell`, this would be `UITableView`.
public protocol CellContainerViewProtocol {

    // MARK: Associated types

    /// The type of cell for this container view.
    associatedtype CellType: UIView & ReusableViewProtocol

    /// The type of supplementary view for this container view.
    associatedtype SupplementaryViewType: UIView & ReusableViewProtocol

    // MARK: Cells

    func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType

    func registerCellClass(_ cellClass: AnyClass?, identifier: String)

    func registerCellNib(_ cellNib: UINib?, identifier: String)

    // MARK: Supplementary views

    func dequeueReusableSupplementaryViewFor(kind: SupplementaryViewKind,
                                             identifier: String,
                                             indexPath: IndexPath) -> SupplementaryViewType?

    func registerSupplementaryViewClass(_ supplementaryClass: AnyClass?,
                                        kind: SupplementaryViewKind,
                                        identifier: String)

    func registerSupplementaryViewNib(_ supplementaryNib: UINib?,
                                      kind: SupplementaryViewKind,
                                      identifier: String)
}

extension UICollectionView: CellContainerViewProtocol {

    /// :nodoc:
    public typealias CellType = UICollectionViewCell

    /// :nodoc:
    public typealias SupplementaryViewType = UICollectionReusableView

    /// :nodoc:
    public func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    /// :nodoc:
    public func registerCellClass(_ cellClass: AnyClass?, identifier: String) {
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerCellNib(_ cellNib: UINib?, identifier: String) {
        self.register(cellNib, forCellWithReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func dequeueReusableSupplementaryViewFor(kind: SupplementaryViewKind,
                                                    identifier: String,
                                                    indexPath: IndexPath) -> SupplementaryViewType? {
        self.dequeueReusableSupplementaryView(ofKind: kind.collectionElementKind,
                                              withReuseIdentifier: identifier,
                                              for: indexPath)
    }

    /// :nodoc:
    public func registerSupplementaryViewClass(_ supplementaryClass: AnyClass?,
                                               kind: SupplementaryViewKind,
                                               identifier: String) {
        self.register(supplementaryClass,
                      forSupplementaryViewOfKind: kind.collectionElementKind,
                      withReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryViewNib(_ supplementaryNib: UINib?,
                                             kind: SupplementaryViewKind,
                                             identifier: String) {
        self.register(supplementaryNib,
                      forSupplementaryViewOfKind: kind.collectionElementKind,
                      withReuseIdentifier: identifier)
    }
}

extension UITableView: CellContainerViewProtocol {

    /// :nodoc:
    public typealias CellType = UITableViewCell

    /// :nodoc:
    public typealias SupplementaryViewType = UITableViewHeaderFooterView

    /// :nodoc:
    public func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

    /// :nodoc:
    public func registerCellClass(_ cellClass: AnyClass?, identifier: String) {
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerCellNib(_ cellNib: UINib?, identifier: String) {
        self.register(cellNib, forCellReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func dequeueReusableSupplementaryViewFor(kind: SupplementaryViewKind,
                                                    identifier: String,
                                                    indexPath: IndexPath) -> SupplementaryViewType? {
        self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryViewClass(_ supplementaryClass: AnyClass?,
                                               kind: SupplementaryViewKind,
                                               identifier: String) {
        self.register(supplementaryClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryViewNib(_ supplementaryNib: UINib?,
                                             kind: SupplementaryViewKind,
                                             identifier: String) {
        self.register(supplementaryNib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
